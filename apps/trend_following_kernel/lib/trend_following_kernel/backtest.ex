defmodule TrendFollowingKernel.Backtest do
  alias TrendFollowing.Markets
  alias TrendFollowingKernel.Position

  def backtest(system, product, config) do
    # 前300个交易日不做任何操作
    dayk_list = 
      Markets.list_dayk(product.symbol)
      |> Enum.slice(300..-1)

    state = %{
      account: config.account,
      position_num: 0,
      schema: nil,
      lot_size: product.lot_size,
      log: []
    }

    if product.lot_size == 0 do
      state
    else
      trading(system, dayk_list, product, config, state)
    end
  end

  defp trading(_system, [], _product, _config, state), do: state
  defp trading(system, [dayk | rest], product, config, state) do
    schema = Position.position(system, product, dayk, Map.put(config, :account, state.account))

    state =
      cond do
        create_position?(state, dayk, schema) ->
          cur_position = Enum.at(schema.positions, 0)
          
          cur_state =
            state
            |> Map.update!(:account, &(&1 - cur_position.buy_price * state.lot_size * schema.unit))
            |> Map.update!(:position_num, &(&1 + 1))
            |> Map.put(:schema, schema)
          
          log = create_position_log(system, dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        add_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num)
          
          cur_state =
            state
            |> Map.update!(:account, &(&1 - cur_position.buy_price * state.lot_size * schema.unit))
            |> Map.update!(:position_num, &(&1 + 1))
          
          log = add_position_log(system, dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        stop_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num - 1)
          position_amount = state.lot_size * schema.unit * state.position_num

          money =
            case schema.trend do
              "bull" -> cur_position.stop_price * position_amount
              "bear" -> cur_position.avg_price * position_amount + (cur_position.avg_price - cur_position.stop_price) * position_amount
            end
          
          cur_state = 
            state
            |> Map.update!(:account, &(&1 + money))
            |> Map.put(:position_num, 0)
            |> Map.put(:schema, nil)
          
          log = stop_position_log(system, dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        close_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num - 1)
          position_amount = state.lot_size * schema.unit * state.position_num
          
          money =
            case schema.trend do
              "bull" -> schema.close_price * position_amount
              "bear" -> cur_position.avg_price * position_amount + (cur_position.avg_price - schema.close_price) * position_amount
            end
          
          cur_state =
            state
            |> Map.update!(:account, &(&1 + money))
            |> Map.put(:position_num, 0)
            |> Map.put(:schema, nil)

          log = close_position_log(system, dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        true -> state
      end

    state = update_close_price(system, state, dayk)

    trading(system, rest, product, config, state)
  end

  defp create_position?(state, dayk, schema) do
    (state.account > 0 &&
    state.position_num == 0 && 
    schema.trend == "bull" && 
    dayk.high > schema.break_price)
    or
    (state.account > 0 &&
    state.position_num == 0 && 
    schema.trend == "bear" && 
    dayk.low < schema.break_price)
  end

  defp add_position?(%{schema: nil}, _dayk), do: false
  defp add_position?(state, dayk) do
    schema = Map.get(state, :schema)
    next_position = Enum.at(schema.positions, state.position_num)

    if is_nil(next_position) do
      false
    else
      position_price = next_position.buy_price *  state.lot_size * schema.unit
      
      (state.account > 0 &&
      state.account > position_price &&
      state.position_num > 0 &&
      state.position_num < schema.position_max &&
      schema.trend == "bull" &&
      dayk.high > next_position.buy_price)
      or
      (state.account > 0 &&
      state.account > position_price &&
      state.position_num > 0 &&
      state.position_num < schema.position_max &&
      schema.trend == "bear" &&
      dayk.low < next_position.buy_price)
    end
  end

  defp stop_position?(%{schema: nil}, _dayk), do: false
  defp stop_position?(state, dayk) do
    schema = Map.get(state, :schema)
    cur_position = Enum.at(schema.positions, state.position_num - 1)

    (state.position_num > 0 &&
    schema.trend == "bull" &&
    dayk.low < cur_position.stop_price)
    or
    (state.position_num > 0 &&
    schema.trend == "bear" &&
    dayk.high > cur_position.stop_price)
  end

  defp close_position?(%{schema: nil}, _dayk), do: false
  defp close_position?(state, dayk) do
    schema = Map.get(state, :schema)

    (state.position_num > 0 &&
    schema.trend == "bull" &&
    dayk.low < schema.close_price)
    or
    (state.position_num > 0 &&
    schema.trend == "bear" &&
    dayk.high > schema.close_price)
  end

  defp create_position_log(system, dayk, before_state, cur_state) do
    schema = Map.get(cur_state, :schema)
    cur_position = Enum.at(schema.positions, cur_state.position_num - 1)

    [
      action: "create_position",
      system: system,
      dayk: dayk,
      before_state: Map.delete(before_state, :log),
      cur_state: Map.delete(cur_state, :log),
      system: 1,
      date: dayk.date,
      price: cur_position.buy_price,
      lot: schema.unit,
      amount: before_state.lot_size * schema.unit,
      trend: schema.trend,
      positions: schema.positions,
    ]
  end

  defp add_position_log(system, dayk, before_state, cur_state) do
    schema = Map.get(cur_state, :schema)
    cur_position = Enum.at(schema.positions, cur_state.position_num - 1)

    %{
      action: "add_position",
      system: system,
      dayk: dayk,
      before_state: Map.delete(before_state, :log),
      cur_state: Map.delete(cur_state, :log),
      date: dayk.date,
      price: cur_position.buy_price,
      lot: schema.unit,
      amount: before_state.lot_size * schema.unit,
    }
  end

  defp stop_position_log(system, dayk, before_state, cur_state) do
    schema = Map.get(before_state, :schema)
    cur_position = Enum.at(schema.positions, before_state.position_num - 1)

    %{
      action: "stop_position",
      system: system,
      dayk: dayk,
      before_state: Map.delete(before_state, :log),
      cur_state: Map.delete(cur_state, :log),
      date: dayk.date,
      price: cur_position.stop_price,
      avg_price: cur_position.avg_price,
      lot: schema.unit * before_state.position_num,
      amount: before_state.lot_size * schema.unit * before_state.position_num,
    }
  end

  defp close_position_log(system, dayk, before_state, cur_state) do
    schema = Map.get(before_state, :schema)
    
    %{
      action: "close_position",
      system: system,
      dayk: dayk,
      before_state: Map.delete(before_state, :log),
      cur_state: Map.delete(cur_state, :log), 
      date: dayk.date,
      trend: schema.trend,
      price: schema.close_price,
      lot: schema.unit * before_state.position_num,
      amount: before_state.lot_size * schema.unit * before_state.position_num 
    }
  end

  defp update_close_price(_system, %{schema: nil} = state, _dayk), do: state
  defp update_close_price(system, state, dayk) do
    close_price = Position.close_price(system, state.schema.trend, dayk)
    put_in(state, [:schema, :close_price], close_price)
  end
end