defmodule JustCi.TemplateController do
  use JustCi.Web, :controller

  alias JustCi.Template
  alias JustCi.Task

  def index(conn, _params) do
    templates = Template |> Repo.all
    render(conn, "index.html", templates: templates)
  end

  def new(conn, _params) do
    changeset = Template.changeset(%Template{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"template" => template_params}) do
    changeset = Template.changeset(%Template{}, template_params)

    case Repo.insert(changeset) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template created successfully.")
        |> redirect(to: template_path(conn, :show, template))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    query = from t in Task, order_by: t.order
    template = Template |> Repo.get!(id) |> Repo.preload(tasks: query)
    render(conn, "show.html", template: template)
  end

  def edit(conn, %{"id" => id}) do
    template = Repo.get!(Template, id)
    changeset = Template.changeset(template)
    render(conn, "edit.html", template: template, changeset: changeset)
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    template = Repo.get!(Template, id)
    changeset = Template.changeset(template, template_params)

    case Repo.update(changeset) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template updated successfully.")
        |> redirect(to: template_path(conn, :show, template))
      {:error, changeset} ->
        render(conn, "edit.html", template: template, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Repo.get!(Template, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(template)

    conn
    |> put_flash(:info, "Template deleted successfully.")
    |> redirect(to: template_path(conn, :index))
  end
end
