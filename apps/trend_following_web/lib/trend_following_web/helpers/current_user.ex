defmodule TrendFollowingWeb.Helpers.CurrentUser do
  import Plug.Conn, only: [assign: 3]
  
  alias TrendFollowingWeb.Helpers.Guardian

  def init(opts \\ []), do: opts

  def call(conn, opts) do
    current_user = Guardian.Plug.current_resource(conn, opts)
    authenticated? = Guardian.Plug.authenticated?(conn, opts)

    conn
    |> assign(:authenticated?, authenticated?)
    |> assign(:current_user, current_user)
  end
end