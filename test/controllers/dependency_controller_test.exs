defmodule JustCi.DependencyControllerTest do
  use JustCi.ConnCase

  alias JustCi.Dependency
  @valid_attrs %{command: "some content", priority: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dependency_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing dependencies"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, dependency_path(conn, :new)
    assert html_response(conn, 200) =~ "New dependency"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, dependency_path(conn, :create), dependency: @valid_attrs
    assert redirected_to(conn) == dependency_path(conn, :index)
    assert Repo.get_by(Dependency, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, dependency_path(conn, :create), dependency: @invalid_attrs
    assert html_response(conn, 200) =~ "New dependency"
  end

  test "shows chosen resource", %{conn: conn} do
    dependency = Repo.insert! %Dependency{}
    conn = get conn, dependency_path(conn, :show, dependency)
    assert html_response(conn, 200) =~ "Show dependency"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    dependency = Repo.insert! %Dependency{}
    conn = get conn, dependency_path(conn, :edit, dependency)
    assert html_response(conn, 200) =~ "Edit dependency"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    dependency = Repo.insert! %Dependency{}
    conn = put conn, dependency_path(conn, :update, dependency), dependency: @valid_attrs
    assert redirected_to(conn) == dependency_path(conn, :show, dependency)
    assert Repo.get_by(Dependency, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    dependency = Repo.insert! %Dependency{}
    conn = put conn, dependency_path(conn, :update, dependency), dependency: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit dependency"
  end

  test "deletes chosen resource", %{conn: conn} do
    dependency = Repo.insert! %Dependency{}
    conn = delete conn, dependency_path(conn, :delete, dependency)
    assert redirected_to(conn) == dependency_path(conn, :index)
    refute Repo.get(Dependency, dependency.id)
  end
end
