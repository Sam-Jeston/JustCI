defmodule JustCi.BuildManager do
  @doc """
  Starts the build manager Agent.
  """
  def start_link do
    Agent.start_link(fn -> [] end, name: :build_manager)
  end

  @doc """
  Gets active jobs within the build manager
  """
  def get_jobs do
    Agent.get(:build_manager, fn list -> list end)
  end

  @doc """
  Pushes a new job into the agent.
  """
  def push(job) do
    Agent.update(:build_manager, fn list -> [job|list] end)
  end

  @doc """
  Removes a completed job from the build manager
  """
  def remove(job) do
    Agent.get_and_update(:build_manager, fn
      []    -> {:ok, []}
      list -> {:ok, fn list -> Enum.filter(list, fn(x) -> x != job end) end}
    end)
  end
end
