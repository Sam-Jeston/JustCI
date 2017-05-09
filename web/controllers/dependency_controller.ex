defmodule JustCi.DependencyController do
  use JustCi.Web, :controller

  alias JustCi.Dependency

  def index(conn, _params) do
    dependencies = Repo.all(Dependency)
    render(conn, "index.html", dependencies: dependencies)
  end

  def new(conn, _params) do
    changeset = Dependency.changeset(%Dependency{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"dependency" => dependency_params}) do
    changeset = Dependency.changeset(%Dependency{}, dependency_params)

    case Repo.insert(changeset) do
      {:ok, _dependency} ->
        conn
        |> put_flash(:info, "Dependency created successfully.")
        |> redirect(to: dependency_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dependency = Repo.get!(Dependency, id)
    render(conn, "show.html", dependency: dependency)
  end

  def edit(conn, %{"id" => id}) do
    dependency = Repo.get!(Dependency, id)
    changeset = Dependency.changeset(dependency)
    render(conn, "edit.html", dependency: dependency, changeset: changeset)
  end

  def update(conn, %{"id" => id, "dependency" => dependency_params}) do
    dependency = Repo.get!(Dependency, id)
    changeset = Dependency.changeset(dependency, dependency_params)

    case Repo.update(changeset) do
      {:ok, dependency} ->
        conn
        |> put_flash(:info, "Dependency updated successfully.")
        |> redirect(to: dependency_path(conn, :show, dependency))
      {:error, changeset} ->
        render(conn, "edit.html", dependency: dependency, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dependency = Repo.get!(Dependency, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(dependency)

    conn
    |> put_flash(:info, "Dependency deleted successfully.")
    |> redirect(to: dependency_path(conn, :index))
  end
end
