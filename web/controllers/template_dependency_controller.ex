defmodule JustCi.TemplateDependencyController do
  use JustCi.Web, :controller

  alias JustCi.Template
  alias JustCi.Dependency
  alias JustCi.TemplateDependency
  alias JustCi.DependencyToTemplate

  def view(conn, %{"id" => id}) do
    { template, dependencies } = view_lookups(id)
    render(conn, "view.html", template: template, dependencies: dependencies)
  end

  def link(conn, params) do
    dependency_id = String.to_integer(params["dependency"]["dependency_id"])
    template_id = String.to_integer(params["id"])

    changeset = %TemplateDependency{
      template_id: template_id,
      dependency_id: dependency_id
    }

    case Repo.insert changeset do
      {:ok, _struct} ->
        conn
        |> put_flash(:info, "Dependency linked successfully.")
        |> redirect(to: template_dependency_path(conn, :view, params["id"]))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "An error occured linking the dependency.")
        |> redirect(to: template_dependency_path(conn, :view, params["id"]))
    end
  end

  def unlink(conn, params) do
    dependency_id = String.to_integer(params["dependency"]["dependency_id"])
    template_id = String.to_integer(params["id"])

    template_dependency = TemplateDependency
    |> where([td], td.template_id == ^template_id and td.dependency_id == ^dependency_id)
    |> Repo.one

    case Repo.delete template_dependency do
      {:ok, _struct} ->
        conn
        |> put_flash(:info, "Dependency unlinked successfully.")
        |> redirect(to: template_dependency_path(conn, :view, params["id"]))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "An error occured unlinking the dependency.")
        |> redirect(to: template_dependency_path(conn, :view, params["id"]))
    end
  end

  def view_lookups (template_id) do
    template = Template |> Repo.get(template_id) |> Repo.preload(:dependencies)
    dependencies = Dependency |> Repo.all
    transformed_dependencies = transform_dependencies(template.dependencies, dependencies)
    { template, transformed_dependencies }
  end

  def transform_dependencies(template_dependencies, all_dependencies) do
    selected_dependencies = Enum.map(template_dependencies, &(%DependencyToTemplate{
      dependency_id: &1.id,
      selected: true,
      command: &1.command
    }))

    selected_dependency_ids = Enum.map(selected_dependencies, &(&1.dependency_id))
    dependency_ids = Enum.map(all_dependencies, &(&1.id))
    unselected_dependency_ids = dependency_ids -- selected_dependency_ids

    dep_unselected = fn dep -> Enum.member?(unselected_dependency_ids, dep.id) end
    unselected_dependencies = Enum.filter(all_dependencies, dep_unselected)
    unselected_dependencies_transform = Enum.map(unselected_dependencies, &(%DependencyToTemplate{
      dependency_id: &1.id,
      selected: false,
      command: &1.command
    }))

    combined_dependencies = selected_dependencies ++ unselected_dependencies_transform
    Enum.sort(combined_dependencies, &(&1.dependency_id <= &2.dependency_id))
  end
end
