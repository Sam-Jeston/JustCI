defmodule JustCi.TaskController do
  use JustCi.Web, :controller

  alias JustCi.Task
  alias JustCi.Template

  def index(conn, _params) do
    tasks = Repo.all(Task)
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, params) do
    changeset = Task.changeset(%Task{}, params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    query = from t in Task, order_by: t.order
    template = Template |> Repo.get!(task_params["template_id"]) |> Repo.preload(tasks: query)
    most_recent_task = List.last(template.tasks)

    merged_task = Map.merge(task_params, %{ "order" => most_recent_task.order + 1 })
    changeset = Task.changeset(%Task{}, merged_task)

    template = Template |> Repo.get!(task_params["template_id"])

    case Repo.insert(changeset) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: template_path(conn, :show, template))
      {:error, changeset} ->
        IO.inspect changeset
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end

  def update_orders(conn, %{"_json" => task_orders}) do
    task_ids = Enum.map(task_orders, fn(t) -> update_order(t) end)
    send_resp(conn, :no_content, "")
  end

  def update_order(%{"id" => id, "order" => order}) do
    task = Repo.get!(Task, id)
    IO.inspect order
    changeset = Task.changeset(task, %{"order" => order})
    Repo.update!(changeset)
  end
end
