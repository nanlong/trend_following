defmodule TrendFollowingWeb.Helpers.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :trend_following_web

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, ensure: true
end