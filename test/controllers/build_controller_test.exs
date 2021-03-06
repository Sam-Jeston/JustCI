defmodule JustCi.BuildControllerTest do
  use JustCi.ConnCase

  alias JustCi.Build
  alias JustCi.Template

  @valid_template_attrs %{name: "some template"}
  @valid_attrs %{repo: "some content"}
  @invalid_attrs %{}

  setup do
    changeset = Template.changeset(%Template{}, @valid_template_attrs)
    template = Repo.insert! changeset
    {:ok, attrs: Map.merge(@valid_attrs, %{template_id: template.id})}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, build_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing builds"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, build_path(conn, :new)
    assert html_response(conn, 200) =~ "New build"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, attrs: attrs} do
    conn = post conn, build_path(conn, :create), build: attrs
    assert redirected_to(conn) == build_path(conn, :index)
    assert Repo.get_by(Build, attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, build_path(conn, :create), build: @invalid_attrs
    assert html_response(conn, 200) =~ "New build"
  end

  test "shows chosen resource", %{conn: conn} do
    build = Repo.insert! %Build{}
    conn = get conn, build_path(conn, :show, build)
    assert html_response(conn, 200) =~ "Show build"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 302, fn ->
      get conn, build_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    build = Repo.insert! %Build{}
    conn = get conn, build_path(conn, :edit, build)
    assert html_response(conn, 200) =~ "Edit build"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, attrs: attrs} do
    build = Repo.insert! %Build{}
    conn = put conn, build_path(conn, :update, build), build: attrs
    assert redirected_to(conn) == build_path(conn, :show, build)
    assert Repo.get_by(Build, attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    build = Repo.insert! %Build{}
    conn = put conn, build_path(conn, :update, build), build: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit build"
  end

  test "deletes chosen resource", %{conn: conn} do
    build = Repo.insert! %Build{}
    conn = delete conn, build_path(conn, :delete, build)
    assert redirected_to(conn) == build_path(conn, :index)
    refute Repo.get(Build, build.id)
  end
end
