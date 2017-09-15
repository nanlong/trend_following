defmodule TrendFollowingKernel.Position do
  
  def position(system, product, dayk, config) do
    # 操作方向
    trend = if dayk.ma50 > dayk.ma300, do: "bull", else: "bear"
    # 突破价
    break_price = break_price(system, trend, dayk)
    # 平仓价
    close_price = close_price(system, trend, dayk)
    # 止损ATR幅度
    atr_stop = config.stop_loss / config.atr_rate
    # 头寸单位规模
    unit = position_unit(config.account, config.atr_rate, dayk.atr, product.lot_size)
    # 头寸单位股数
    unit_share = unit * product.lot_size
    # 当前资金可操作的最大头寸规模
    position_max = config.position_max || 4
    # 成本价
    total_avg_price = avg_price(trend, break_price, dayk.atr, config.atr_add, position_max)
    
    %{
      system: system,
      date: dayk.date,
      symbol: dayk.symbol,
      account_min: account_min(dayk.atr, product.lot_size, config.atr_rate),
      trend: trend,
      atr: dayk.atr,
      break_price: break_price,
      close_price: close_price,
      unit: unit,
      unit_share: unit_share,
      position_max: position_max,
      total_unit: unit * position_max,
      total_unit_share: unit_share * position_max,
      total_unit_cost: total_avg_price * position_max * unit_share,
      positions: Enum.map(1..position_max, fn(p) -> 
        buy_price = buy_price(trend, break_price, dayk.atr, config.atr_add, p)
        avg_price = avg_price(trend, break_price, dayk.atr, config.atr_add, p)
        stop_price = stop_price(trend, break_price, dayk.atr, config.atr_add, atr_stop, p)
        
        %{
          buy_price: buy_price,
          avg_price: avg_price,
          stop_price: stop_price,
          unit_cost: buy_price * unit_share,
        }
      end),
    }
  end

  @doc """
  突破价
  """
  def break_price(:system1, trend, dayk) do
    if trend == "bull", do: dayk.high20, else: dayk.low20
  end
  def break_price(:system2, trend, dayk) do
    if trend == "bull", do: dayk.high60, else: dayk.low60
  end

  @doc """
  平仓价
  """
  def close_price(:system1, trend, dayk) do
    if trend == "bull", do: dayk.low10, else: dayk.high10
  end
  def close_price(:system2, trend, dayk) do
    if trend == "bull", do: dayk.low20, else: dayk.high20
  end

  @doc """
  最低账户资金
  """
  def account_min(atr, lot_size, atr_rate) do
    atr * lot_size / atr_rate |> round
  end

  @doc """
  头寸规模
  """
  def position_unit(account, atr_rate , atr, lot_size) do
    (account * atr_rate) / (atr * lot_size) |> Float.floor(0) |> round()
  end

  @doc """
  头寸成本
  """
  def position_cost(trend, dayk, config, break_price, unit, position) do
    Enum.map(1..position, fn(p) -> 
      buy_price(trend, break_price, dayk.atr, config.atr_add, p) * unit
    end)
    |> Enum.sum()
    |> Float.round(4)
  end

  @doc """
  最大头寸
  """
  def position_max(trend, dayk, config, break_price, unit) do
    if position_cost(trend, dayk, config, break_price, unit, config.position_max) < config.account do
      config.position_max
    else
      position_max(trend, dayk, config, break_price, unit, 1)
    end
  end
  def position_max(trend, dayk, config, break_price, unit, position) do
    if position_cost(trend, dayk, config, break_price, unit, position + 1) > config.account do
      position
    else
      position_max(trend, dayk, config, break_price, unit, position + 1)
    end
  end

  @doc """
  买入价
  """
  def buy_price(trend, break_price, atr, atr_add, position) do
    scope = atr * atr_add * (position - 1)

    if trend == "bull" do
      break_price + scope
    else
      break_price - scope
    end
    |> Float.round(4)
  end

  @doc """
  平均价
  """
  def avg_price(trend, break_price, atr, atr_add, position) do
    price = break_price * position
    scope = atr * atr_add * Enum.sum(1..position - 1)

    cond do
      position == 1 -> price
      trend == "bull" -> price + scope
      trend == "bear" -> price - scope
    end
    |> Kernel./(position)
    |> Float.round(4)
  end

  @doc """
  止损价
  """
  def stop_price(trend, break_price, atr, atr_add, atr_stop, position) do
    avg_price = avg_price(trend, break_price, atr, atr_add, position)
    scope = atr * (atr_stop / position)

    if trend == "bull" do
      avg_price - scope
    else
      avg_price + scope
    end
    |> Float.round(4)
  end
end