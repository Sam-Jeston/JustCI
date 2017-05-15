defmodule JustCi.DependencyToTemplate do
  @derive {Phoenix.Param, key: :dependency_id}
  defstruct [:dependency_id, :selected, :command]
end
