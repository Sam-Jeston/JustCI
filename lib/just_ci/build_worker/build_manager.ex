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
    Agent.get(:build_manager, &(&1))
  end

  @doc """
  Pushes a new job into the build manager.
  """
  def push(job) do
    Agent.update(:build_manager, &([job|&1]))
  end

  @doc """
  Removes a completed job from the build manager
  """
  def remove(job) do
    IO.inspect job
    Agent.update(:build_manager, &Enum.filter(&1, fn(x) -> x != job end))
  end
end
