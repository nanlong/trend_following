defmodule TrendFollowingKernel.Backtest do
  alias TrendFollowing.Markets
  alias TrendFollowingKernel.Position

  def backtest(symbol, config) do
    stock = Markets.get_stock!(symbol)
    dayk_list = Markets.list_dayk(symbol)

    state = %{
      account: config.account,
      position_num: 0,
      schema: nil,
      log: []
    }

    trading(dayk_list, stock, config, state)
  end

  defp trading([], _stock, _config, state), do: state
  defp trading([dayk | rest], stock, config, state) do
    schema = Position.position(:system1, stock, dayk, Map.put(config, :account, state.account))

    state =
      cond do
        create_position?(state, dayk, schema) ->
          cur_position = Enum.at(schema.positions, 0)
          create_position_log = create_position_log(state, dayk, schema)

          state
          |> Map.update!(:account, &(&1 - cur_position.buy_price * schema.unit))
          |> Map.update!(:position_num, &(&1 + 1))
          |> Map.put(:schema, schema)
          |> Map.update!(:log, &(&1 ++ [create_position_log]))

        add_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num)
          add_position_log = add_position_log(state, dayk)

          state
          |> Map.update!(:account, &(&1 - cur_position.buy_price * schema.unit))
          |> Map.update!(:position_num, &(&1 + 1))
          |> Map.update!(:log, &(&1 ++ [add_position_log]))

        stop_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num - 1)
          stop_position_log = stop_position_log(state, dayk)

          state
          |> Map.update!(:account, &(&1 + cur_position.stop_price * schema.unit * state.position_num))
          |> Map.put(:position_num, 0)
          |> Map.update!(:log, &(&1 ++ [stop_position_log]))

        close_position?(state, dayk) ->
          close_position_log = close_position_log(state, dayk)

          state
          |> Map.update!(:account, &(&1 + state.close_price * schema.unit * state.position_num))
          |> Map.put(:position_num, 0)
          |> Map.update!(:log, &(&1 ++ [close_position_log]))

        true -> state
      end

    trading(rest, stock, config, state)
  end

  defp create_position?(state, dayk, schema) do
    (state.position_num == 0 && 
    schema.trend == "bull" && 
    dayk.high > schema.break_price)
    or
    (state.position_num == 0 && 
    schema.trend == "bear" && 
    dayk.low < schema.break_price)
  end

  defp add_position?(state, dayk) do
    schema = Map.get(state, :schema)
    next_position = Enum.at(schema.positions, state.position_num)

    (state.position_num > 0 &&
    state.position_num < schema.position_max &&
    schema.trend == "bull" &&
    dayk.high > next_position.buy_price)
    or
    (state.position_num > 0 &&
    state.position_num < schema.position_max &&
    schema.trend == "bear" &&
    dayk.low < next_position.buy_price)
  end

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

  defp create_position_log(_state, dayk, schema) do
    %{
      action: "create",
      date: dayk.date,
      trend: schema.trend,
      price: schema.break_price,
      amount: schema.unit,
    }
  end

  defp add_position_log(state, dayk) do
    schema = Map.get(state, :schema)
    cur_position = Enum.at(schema.positions, state.position_num)

    %{
      action: "add",
      date: dayk.date,
      trend: schema.trend,
      price: cur_position.buy_price,
      amount: schema.unit
    }
  end

  defp stop_position_log(state, dayk) do
    schema = Map.get(state, :schema)
    cur_position = Enum.at(schema.positions, state.position_num - 1)

    %{
      action: "stop",
      date: dayk.date,
      trend: schema.trend,
      price: cur_position.stop_price,
      amount: schema.unit * state.position_num
    }
  end

  defp close_position_log(state, dayk) do
    schema = Map.get(state, :schema)

    %{
      action: "close",
      date: dayk.date,
      trend: schema.trend,
      price: schema.close_price,
      amount: schema.unit * state.position_num
    }
  end
end