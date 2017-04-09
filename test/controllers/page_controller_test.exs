defmodule JustCi.HomeControllerTest do
  use JustCi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Your CI"
  end
end
