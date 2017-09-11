defmodule TrendFollowingKernel.Backtest do
  @moduledoc """
  config = %{
    account: 1000000, 
    atr_rate: 0.01, 
    atr_add: 0.5,
    stop_loss: 0.02,
    position_max: 4,
  }
  """
  alias TrendFollowing.Markets
  alias TrendFollowingKernel.Position

  def backtest(symbol, config) do
    stock = Markets.get_stock!(symbol)

    # 前300个交易日不做任何操作
    dayk_list = 
      Markets.list_dayk(symbol)
      |> Enum.slice(300..-1)

    state = %{
      account: config.account,
      position_num: 0,
      schema: nil,
      lot_size: stock.lot_size,
      log: []
    }

    trading(dayk_list, stock, config, state)
    # |> read_log()
  end

  defp trading([], _stock, _config, state), do: state
  defp trading([dayk | rest], stock, config, state) do
    schema = Position.position(:system1, stock, dayk, Map.put(config, :account, state.account))

    state =
      cond do
        create_position?(state, dayk, schema) ->
          cur_position = Enum.at(schema.positions, 0)
          
          cur_state =
            state
            |> Map.update!(:account, &(&1 - cur_position.buy_price * schema.unit))
            |> Map.update!(:position_num, &(&1 + 1))
            |> Map.put(:schema, schema)
          
          log = create_position_log(dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        add_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num)
          
          cur_state =
            state
            |> Map.update!(:account, &(&1 - cur_position.buy_price * schema.unit))
            |> Map.update!(:position_num, &(&1 + 1))
          
          log = add_position_log(dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        stop_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num - 1)
          
          position_amount = schema.unit * state.lot_size * state.position_num

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
          
          log = stop_position_log(dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        close_position?(state, dayk) ->
          schema = Map.get(state, :schema)
          cur_position = Enum.at(schema.positions, state.position_num - 1)
          position_amount = schema.unit * state.lot_size * state.position_num
          
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

          log = close_position_log(dayk, state, cur_state)
          Map.update!(cur_state, :log, &(&1 ++ [log]))

        true -> state
      end

    state = update_close_price(state, dayk)

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

  defp add_position?(%{schema: nil}, _dayk), do: false
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

  defp create_position_log(dayk, before_state, cur_state) do
    schema = Map.get(cur_state, :schema)
    cur_position = Enum.at(schema.positions, cur_state.position_num - 1)

    %{
      action: "create",
      dayk: dayk,
      before_state: before_state,
      cur_state: cur_state,
      system: 1,
      date: dayk.date,
      trend: schema.trend,
      price: schema.break_price,
      amount: schema.unit,
      before_account: before_state.account,
      cur_account: cur_state.account,
      schema: schema,
      cur_position: cur_position,
      cur_position_num: cur_state.position_num,
    }
  end

  defp add_position_log(dayk, before_state, cur_state) do
    schema = Map.get(cur_state, :schema)
    cur_position = Enum.at(schema.positions, before_state.position_num)

    %{
      action: "add",
      dayk: dayk,
      before_state: before_state,
      cur_state: cur_state,
      date: dayk.date,
      trend: schema.trend,
      price: cur_position.buy_price,
      amount: schema.unit,
      before_account: before_state.account,
      cur_account: cur_state.account,
      cur_position: cur_position,
      cur_position_num: cur_state.position_num,
    }
  end

  defp stop_position_log(dayk, before_state, cur_state) do
    schema = Map.get(before_state, :schema)
    cur_position = Enum.at(schema.positions, before_state.position_num - 1)

    %{
      action: "stop",
      dayk: dayk,
      before_state: before_state,
      cur_state: cur_state,
      date: dayk.date,
      trend: schema.trend,
      price: cur_position.stop_price,
      amount: schema.unit * before_state.position_num,
      before_account: before_state.account,
      cur_account: cur_state.account,
      cur_position: cur_position,
      cur_position_num: cur_state.position_num,
    }
  end

  defp close_position_log(dayk, before_state, cur_state) do
    schema = Map.get(before_state, :schema)
    cur_position = Enum.at(schema.positions, before_state.position_num - 1)

    %{
      action: "close",
      dayk: dayk,
      before_state: before_state,
      cur_state: cur_state,
      system: 1,
      date: dayk.date,
      trend: schema.trend,
      price: schema.close_price,
      amount: schema.unit * before_state.position_num,
      before_account: before_state.account,
      cur_account: cur_state.account,
      cur_position: cur_position,
      cur_position_num: cur_state.position_num,
    }
  end

  defp update_close_price(%{schema: nil} = state, _dayk), do: state
  defp update_close_price(state, dayk) do
    close_price = Position.close_price(:system1, state.schema.trend, dayk)
    put_in(state, [:schema, :close_price], close_price)
  end

  defp read_log(state) do
    create_tmp = """
      <%= @date %>
      当前持有资金 <%= @before_account %>,
      由于价格突破了<%= if @system == 1, do: 20, else: 60 %>日<%= if @trend == "bull", do: "最高", else: "最低" %>价<%= @price %>元,
      所以以<%= @price %>的价格，买入<%= @amount %>股股票<%= if @trend == "bull", do: "做多", else: "做空" %>
      花费 <%= @price * @amount %> 元，
      账户剩余 <%= @cur_account %>
    """

    add_tmp = """
      <%= @date %>
      当前持有资金<%= @before_account %>元，
      由于价格突破了第<%= @cur_position_num %>头寸的购买价，
      所以以<%= @price %>元价格加仓，
      买入<%= @amount %>股，
      花费<%= @price * @amount %>元，
      账户剩余<%= @cur_account %>元。
    """

    stop_tmp = """
      <%= @date %>
      当前持有资金<%= @before_account %>元，
      由于价格突破了当前持有头寸的止损价<%= @price %>元，
      所以以<%= @price %>元的价格卖出<%= @amount %>股，
      损失<%= (@price - @cur_position.avg_price) * @amount %>元，
      账户剩余<%= @cur_account %>元。
    """

    close_tmp = """
      <%= @date %>
      当前持有资金<%= @before_account %>元，
      由于价格突破了近<%= if @system == 1, do: 10, else: 20 %>日<%= if @trend == "bull", do: "最低", else: "最高" %>价<%= @price %>元，
      所以以<%= @price %>元价格平仓，卖出<%= @amount %>股，
      花费成本：<%= @cur_position.avg_price * @amount %>,
      <%= if @trend == "bull" do %>
      盈利<%= (@price - @cur_position.avg_price) * @amount %>元，
      <% else %>
      盈利<%= (@cur_position.avg_price - @price) * @amount %>元,
      <% end %>
      账户剩余<%= @cur_account %>元。
    """

    Enum.map(state.log, fn(x) ->       
      case x.action do
        "create" ->
          EEx.eval_string(create_tmp, assigns: x)
        "add" ->
          EEx.eval_string(add_tmp, assigns: x)
        "stop" ->
          EEx.eval_string(stop_tmp, assigns: x)
        "close" ->
          EEx.eval_string(close_tmp, assigns: x)
      end

    end)
  end
end