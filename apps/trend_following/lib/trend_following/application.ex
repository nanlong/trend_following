defmodule TrendFollowing.Application do
  @moduledoc """
  The TrendFollowing Application Service.

  The trend_following system business domain lives in this application.

  Exposes API to clients such as the `TrendFollowingWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(TrendFollowing.Repo, []),
    ], strategy: :one_for_one, name: TrendFollowing.Supervisor)
  end
end
