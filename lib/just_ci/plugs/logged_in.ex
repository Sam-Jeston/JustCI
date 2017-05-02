defmodule JustCi.Plugs.LoggedInRedirect do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default
  def call(conn, _default), do: redirect(conn)

  defp redirect(conn) do
    registration_path = String.contains?(conn.request_path, "registrations")
    already_redirected_to_login = String.contains?(conn.request_path, "login")
    current_user = JustCi.Session.current_user(conn)

    if (!current_user && !already_redirected_to_login && !registration_path) do
      conn
      |> redirect(to: JustCi.Router.Helpers.session_path(conn, :new))
    else
      conn = assign(conn, :current_user, current_user)
    end

    conn
  end
end
