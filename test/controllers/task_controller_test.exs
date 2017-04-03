defmodule JustCi.TaskControllerTest do
  use JustCi.ConnCase

  alias JustCi.Task
  alias JustCi.Template

  @valid_template_attrs %{name: "some template"}
  @invalid_attrs %{}
  @valid_attrs %{command: "some content", description: "some content"}

  setup do
    changeset = Template.changeset(%Template{}, @valid_template_attrs)
    template = Repo.insert! changeset
    [template: template]
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, task_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing tasks"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, task_path(conn, :new)
    assert html_response(conn, 200) =~ "New task"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, task_path(conn, :create), task: @valid_attrs
    assert redirected_to(conn) == task_path(conn, :index)
    assert Repo.get_by(Task, @valid_attrs)
  end

  test "shows chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = get conn, task_path(conn, :show, task)
    assert html_response(conn, 200) =~ "Show task"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    # Here we will get redirected
    assert_error_sent 302, fn ->
      get conn, task_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = get conn, task_path(conn, :edit, task)
    assert html_response(conn, 200) =~ "Edit task"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    attrs = Map.merge(@valid_attrs, %{template_id: context[:template].id})
    task = Repo.insert! %Task{}
    conn = put conn, task_path(conn, :update, task), task: attrs
    assert redirected_to(conn) == task_path(conn, :show, task)
    assert Repo.get_by(Task, attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = put conn, task_path(conn, :update, task), task: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit task"
  end

  test "deletes chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = delete conn, task_path(conn, :delete, task)
    assert redirected_to(conn) == task_path(conn, :index)
    refute Repo.get(Task, task.id)
  end
end
