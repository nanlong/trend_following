defmodule TrendFollowingWeb.HKStockView do
  use TrendFollowingWeb, :view

  @doc """
  涨跌额
  """
  def diff(%{close: close, pre_close: pre_close}, precision \\ 2) do
    close - pre_close |> Float.round(precision)
  end

  @doc """
  涨跌幅
  """
  def chg(%{pre_close: pre_close} = dayk, precision \\ 2) do
    diff(dayk, precision) / pre_close * 100 |> Float.round(precision)
  end

  @doc """
  振幅
  """
  def amplitude(%{high: high, low: low, pre_close: pre_close}, precision \\ 2) do
    (high - low) / pre_close * 100 |> Float.round(precision)
  end

  def number_human(data, key, precision \\ 2) do
    value = Map.get(data, key)
    {value, _} = Integer.parse(value)

    cond do
      value > 100_000_000 -> 
        (value / 100_000_000) 
        |> Float.round(precision) 
        |> Float.to_string()
        |> Kernel.<>("亿")
      
      value > 10_000 ->
        (value / 10_000) 
        |> Float.round(precision) 
        |> Float.to_string()
        |> Kernel.<>("万")
      
      value == 0 -> "--"
      true -> value
    end
  end

  def number_round(value, precision \\ 2)
  def number_round(value, precision) when is_bitstring(value) do
    {value, _} = Float.parse(value)
    number_round(value, precision)
  end
  def number_round(value, _precision) when value == 0, do: "--"
  def number_round(value, precision), do: Float.round(value, precision)

  def truncate(text, options \\ []) do
    len = options[:length] || 30
    omi = options[:omission] || "..."

    cond do
     !String.valid?(text)       -> text
      String.length(text) < len -> text
      true -> "#{String.slice(text, 0, len - String.length(omi))}#{omi}"
    end
  end

  def to_keyword(data) when is_map(data) do
    Enum.map(data, fn({key, value}) -> {String.to_atom(key), value} end)
  end
end
