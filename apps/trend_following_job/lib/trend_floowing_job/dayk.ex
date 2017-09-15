defmodule TrendFollowingJob.Dayk do
  @moduledoc """

  Examples:
  
    iex> TrendFollowingJob.Dayk.load("cn", "sh600036")
    iex> TrendFollowingJob.Dayk.load("hk", "00700")
    iex> TrendFollowingJob.Dayk.load("us", "AAPL")
    iex> TrendFollowingJob.Dayk.load("i", "TA0")
    iex> TrendFollowingJob.Dayk.load("g", "CL")
  """

  alias TrendFollowing.Repo
  alias TrendFollowing.Markets
  alias TrendFollowing.Markets.Dayk

  def perform(market, symbol), do: load(market, symbol)

  def load(market, symbol) do
    history = Markets.list_dayk(symbol, 400)
    last_dayk = List.last(history)
    %{body: data} = dayk_data(market, symbol)

    data
    |> dayk_rename_key(market, symbol)
    |> dayk_filter(last_dayk)
    |> Enum.with_index()
    |> dayk_pre_close(last_dayk)
    |> dayk_join_history(history)
    |> Enum.with_index()
    |> dayk_donchian_channel()
    |> dayk_moving_average()
    |> dayk_true_range()
    |> dayk_average_true_range()
    |> dayk_save(market, symbol)
  end

  defp dayk_data(market, symbol)
  defp dayk_data("cn", symbol), do: TrendFollowingData.Sina.CNStock.get("dayk", symbol: symbol)
  defp dayk_data("hk", symbol), do: TrendFollowingData.Sina.HKStock.get("dayk", symbol: symbol)
  defp dayk_data("us", symbol), do: TrendFollowingData.Sina.USStock.get("dayk", symbol: symbol)
  defp dayk_data("i", symbol), do: TrendFollowingData.Sina.IFuture.get("dayk", symbol: symbol)
  defp dayk_data("g", symbol), do: TrendFollowingData.Sina.GFuture.get("dayk", symbol: symbol)

  defp dayk_filter(data, nil), do: data
  defp dayk_filter(data, %{date: date}) do
    Enum.filter(data, fn(x) -> Date.compare(date, x.date) == :lt end)
  end

  defp dayk_rename_key(data, market, symbol)
  defp dayk_rename_key(data, "cn", symbol) do
    Enum.map(data, fn(x) -> 
      date = x |> Map.get("day") |> Date.from_iso8601!()
      {open, _} = x |> Map.get("open") |> Float.parse()
      {close, _} = x |> Map.get("close") |> Float.parse()
      {high, _} = x |> Map.get("high") |> Float.parse()
      {low, _} = x |> Map.get("low") |> Float.parse()
      volume = x |> Map.get("volume")

      %{
        symbol: symbol,
        date: date,
        open: open,
        close: close,
        high: high,
        low: low,
        volume: volume,
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now(), 
      }
    end)
  end
  defp dayk_rename_key(data, "hk", symbol) do
    Enum.map(data, fn(x) -> 
      {:ok, datetime, _} = x |> Map.get("date") |> DateTime.from_iso8601()
      date = datetime |> DateTime.to_date()
      {open, _} = x |> Map.get("open") |> to_string() |> Float.parse()
      {close, _} = x |> Map.get("close") |> to_string() |> Float.parse()
      {high, _} = x |> Map.get("high") |> to_string() |> Float.parse()
      {low, _} = x |> Map.get("low") |> to_string() |> Float.parse()
      volume = x |> Map.get("volume") |> to_string()

      %{
        symbol: symbol,
        date: date,
        open: open,
        close: close,
        high: high,
        low: low,
        volume: volume,
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now(), 
      }
    end)
  end
  defp dayk_rename_key(data, "us", symbol) do
    Enum.map(data, fn(x) -> 
      date = x |> Map.get("d") |> Date.from_iso8601!()
      {open, _} = x |> Map.get("o") |> Float.parse()
      {close, _} = x |> Map.get("c") |> Float.parse()
      {high, _} = x |> Map.get("h") |> Float.parse()
      {low, _} = x |> Map.get("l") |> Float.parse()
      volume = x |> Map.get("v")

      %{
        symbol: symbol,
        date: date,
        open: open,
        close: close,
        high: high,
        low: low,
        volume: volume,
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now(), 
      }
    end)
  end
  defp dayk_rename_key(data, "i", symbol) do
    Enum.map(data, fn(x) -> 
      date = x |> Map.get("d") |> Date.from_iso8601!()
      {open, _} = x |> Map.get("o") |> Float.parse()
      {close, _} = x |> Map.get("c") |> Float.parse()
      {high, _} = x |> Map.get("h") |> Float.parse()
      {low, _} = x |> Map.get("l") |> Float.parse()
      volume = x |> Map.get("v")

      %{
        symbol: symbol,
        date: date,
        open: (if open <= 0, do: close, else: open),
        close: close,
        high: high,
        low: low,
        volume: volume,
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now(), 
      }
    end)
  end
  defp dayk_rename_key(data, "g", symbol) do
    Enum.map(data, fn(x) -> 
      date = x |> Map.get("date") |> Date.from_iso8601!()
      {open, _} = x |> Map.get("open") |> Float.parse()
      {close, _} = x |> Map.get("close") |> Float.parse()
      {high, _} = x |> Map.get("high") |> Float.parse()
      {low, _} = x |> Map.get("low") |> Float.parse()
      volume = x |> Map.get("volume")

      %{
        symbol: symbol,
        date: date,
        open: (if open <= 0, do: close, else: open),
        close: close,
        high: high,
        low: low,
        volume: volume,
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now(), 
      }
    end)
  end

  defp dayk_pre_close(data, last_dayk) do
    Enum.map(data, fn({x, index}) -> 
      pre_close =
        if index == 0 do
          (if is_nil(last_dayk), do: x, else: last_dayk) |> Map.get(:close)
        else
          Enum.at(data, index - 1) |> elem(0) |> Map.get(:close)
        end 

      Map.put(x, :pre_close, pre_close)
    end)
  end

  defp dayk_join_history(data, history), do: history ++ data

  defp dayk_donchian_channel([]), do: []
  defp dayk_donchian_channel(data), do: dayk_donchian_channel(data, data, [])
  defp dayk_donchian_channel([], _history, results), do: results
  defp dayk_donchian_channel([{%Dayk{}, _} = data | rest], history, results), do: dayk_donchian_channel(rest, history, results ++ [data])
  defp dayk_donchian_channel([{dayk, index} = data | rest], history, results) do
    %{max: high10, min: low10} = donchian_channel(data, history, 10)
    %{max: high20, min: low20} = donchian_channel(data, history, 20)
    %{max: high60, min: low60} = donchian_channel(data, history, 60)

    dayk =
      dayk
      |> Map.put_new(:high10, high10)
      |> Map.put_new(:high20, high20)
      |> Map.put_new(:high60, high60)
      |> Map.put_new(:low10, low10)
      |> Map.put_new(:low20, low20)
      |> Map.put_new(:low60, low60)

    dayk_donchian_channel(rest, history, results ++ [{dayk, index}])
  end

  defp donchian_channel({_, index}, history, cycle) do
    range_start = Enum.max([index - cycle, 0])
    range_end = Enum.max([index - 1, 0])

    history_range =
      Enum.slice(history, range_start..range_end)
      |> Enum.map(fn({x, _}) -> x end)

    max = (for item <- history_range, do: item.high) |> Enum.max()
    min = (for item <- history_range, do: item.low) |> Enum.min()

    %{max: max, min: min}
  end

  defp dayk_moving_average([]), do: []
  defp dayk_moving_average(data), do: dayk_moving_average(data, data, [])
  defp dayk_moving_average([], _history, results), do: results
  defp dayk_moving_average([{%Dayk{}, _} = data | rest], history, results), do: dayk_moving_average(rest, history, results ++ [data])
  defp dayk_moving_average([{dayk, index} = data | rest], history, results) do
    %{value: ma5} = moving_average(data, history, 5)
    %{value: ma10} = moving_average(data, history, 10)
    %{value: ma20} = moving_average(data, history, 20)
    %{value: ma30} = moving_average(data, history, 30)
    %{value: ma50} = moving_average(data, history, 50)
    %{value: ma300} = moving_average(data, history, 300)

    dayk =
      dayk
      |> Map.put_new(:ma5, ma5)
      |> Map.put_new(:ma10, ma10)
      |> Map.put_new(:ma20, ma20)
      |> Map.put_new(:ma30, ma30)
      |> Map.put_new(:ma50, ma50)
      |> Map.put_new(:ma300, ma300)
    
    dayk_moving_average(rest, history, results ++ [{dayk, index}])
  end

  defp moving_average({_, index}, history, cycle) do
    range_start = Enum.max([index - cycle + 1, 0])
    range_end = index

    history_range =
      Enum.slice(history, range_start..range_end)
      |> Enum.map(fn({x, _}) -> x end)

    len = if length(history_range) < cycle, do: length(history_range), else: cycle

    value = 
      (for item <- history_range, do: item.close) 
      |> Enum.sum() 
      |> Kernel./(len)
      |> Float.round(4)

    %{value: value}
  end
  
  defp dayk_true_range([]), do: []
  defp dayk_true_range(data) when is_list(data), do: dayk_true_range(data, [])
  defp dayk_true_range([], results), do: results
  defp dayk_true_range([{%Dayk{}, _} = data | rest], results), do: dayk_true_range(rest, results ++ [data])
  defp dayk_true_range([{dayk, index} | rest], results) do
    max = Enum.max([dayk.pre_close, dayk.high, dayk.low])
    min = Enum.min([dayk.pre_close, dayk.high, dayk.low])
    dayk = Map.put_new(dayk, :tr, max - min |> Float.round(4))
    dayk_true_range(rest, results ++ [{dayk, index}])
  end

  defp dayk_average_true_range([]), do: []
  defp dayk_average_true_range(data), do: dayk_average_true_range(data, [])
  defp dayk_average_true_range([], results), do: results
  defp dayk_average_true_range([{%Dayk{}, _} = data | rest], results), do: dayk_average_true_range(rest, results ++ [data])
  defp dayk_average_true_range([{dayk, index} | rest], results) when index < 20 do
    dayk = Map.put_new(dayk, :atr, dayk.tr)
    dayk_average_true_range(rest, results ++ [{dayk, index}])
  end
  defp dayk_average_true_range([{dayk, index} | rest], results) when index == 20 do
    atr =
      (for {dayk, _} <- results, do: dayk.tr)
      |> Enum.sum()
      |> Kernel./(20)
      |> Float.round(4)
    
    dayk = Map.put_new(dayk, :atr, atr)
    dayk_average_true_range(rest, results ++ [{dayk, index}])
  end 
  defp dayk_average_true_range([{dayk, index} | rest], results) do
    pre_atr = results |> List.last() |> elem(0) |> Map.get(:atr)
    atr = (pre_atr * 19 + dayk.tr) / 20 |> Float.round(4)
    dayk = Map.put_new(dayk, :atr, atr)
    dayk_average_true_range(rest, results ++ [{dayk, index}])
  end

  defp dayk_save(data, market, symbol) do
    data
    |> Enum.map(fn({x, _}) -> x end)
    |> Enum.filter(fn(x) -> not Map.has_key?(x, :__struct__) end)
    |> Enum.chunk_every(2730)
    |> Enum.map(fn(data_chunk) -> 
      {_num, results} = Repo.insert_all(Dayk, data_chunk, returning: true)
      dayk_id = results |> List.last() |> Map.get(:id)
      update_dayk_id(market, symbol, dayk_id)
    end)
  end

  defp update_dayk_id(market, symbol, dayk_id) when market in ["cn", "hk", "us"] do
    stock = Markets.get_stock(symbol)
    Markets.update_stock(stock, %{dayk_id: dayk_id})
  end
  defp update_dayk_id(market, symbol, dayk_id) when market in ["i", "g"] do
    future = Markets.get_future(symbol)
    Markets.update_future(future, %{dayk_id: dayk_id})
  end
end