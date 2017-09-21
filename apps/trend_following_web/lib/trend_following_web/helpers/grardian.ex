defmodule TrendFollowingWeb.Helpers.Guardian do
  use Guardian, otp_app: :trend_following_web
  
  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    {:ok, claims["sub"]}
  end
  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end