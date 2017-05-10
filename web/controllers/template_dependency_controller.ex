defmodule JustCi.TemplateDependencyController do
  use JustCi.Web, :controller

  alias JustCi.Template
  alias JustCi.Dependency
  alias JustCi.TemplateDependency

  def view(conn, %{"id" => id}) do
    template = Template |> Repo.get(id) |> Repo.preload(:dependencies)
    dependencies = Dependency |> Repo.all
    transformed_dependencies = transform_dependencies(template.dependencies, dependencies)

    IO.inspect transformed_dependencies
    render(conn, "view.html", template: template, dependencies: transformed_dependencies)
  end

  def link(conn, _params) do
  end

  def transform_dependencies(template_dependencies, all_dependencies) do
    selected_dependencies = Enum.map(template_dependencies, &(%{
      dependency_id: &1.id,
      selected: true,
      command: &1.command
    }))

    selected_dependency_ids = Enum.map(selected_dependencies, &(&1[:dependency_id]))
    dependency_ids = Enum.map(all_dependencies, &(&1.id))
    unselected_dependency_ids = dependency_ids -- selected_dependency_ids

    dep_unselected = fn dep -> Enum.member?(unselected_dependency_ids, dep.id) end
    unselected_dependencies = Enum.filter(all_dependencies, dep_unselected)
    unselected_dependencies_transform = Enum.map(unselected_dependencies, &(%{
      dependency_id: &1.id,
      selected: false,
      command: &1.command
    }))

    selected_dependencies ++ unselected_dependencies_transform
  end
end
