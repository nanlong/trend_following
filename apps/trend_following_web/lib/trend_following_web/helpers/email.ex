defmodule TrendFollowingWeb.Helpers.Email do
  use Bamboo.Phoenix, view: TrendFollowingWeb.EmailView

  alias TrendFollowing.Accounts.User
  alias TrendFollowingWeb.Helpers.Mailer

  @from "趋势跟踪系统<support@mg.trendfollowing.cc>"

  @doc """
  欢迎邮件
  """
  def welcome(address) do
    base_email()
    |> to(address)
    |> subject("欢迎注册")
    |> render(:welcome)
    |> Mailer.deliver_later()
  end

  @doc """
  找回密码邮件
  """
  def password_reset(%User{} = user, token) do 
    base_email()
    |> to({user.nickname, user.email})
    |> subject("找回您的账号密码")
    |> assign(:user, user)
    |> assign(:token, token)
    |> render(:password_reset)
    |> Mailer.deliver_later()
  end

  defp base_email do
    new_email()
    |> from(@from)
  end
end