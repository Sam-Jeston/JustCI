defmodule JustCi.BuildWorker do
  import Plug.Conn

  def start (build_id) do
    # TODO: We need to add a new table called jobs, that holds all details
    # for builds completed

    # This should also be managed by the Agent
    # 1. Create a new job entry
    # 2. Start the job (Elixir.Task)
    # 3. Push it to the Agent for reference
  end
end
