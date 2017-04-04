defmodule JustCi.BuildManager do
  @doc """
  Starts the build manager Agent.
  """
  def start_link do
    Agent.start_link(fn -> [] end)
  end

  @doc """
  Gets active jobs within the build manager
  """
  def get_jobs (manager) do
    Agent.get(manager, &(&1))
  end

  @doc """
  Pushes a new job into the build manager.
  """
  def push(manager, job) do
    Agent.update(manager, &([job|&1]))
  end

  @doc """
  Removes a completed job from the build manager
  """
  def remove(manager, job) do
    Agent.update(manager, &Enum.filter(&1, fn(x) -> x != job end))
  end
end
