defmodule JustCi.Plugs.LoggedInRedirect do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  def init(default), do: default
  def call(conn, _default), do: redirect(conn)

  defp redirect(conn) do
    registration_path = String.contains?(conn.request_path, "registrations")
    already_redirected_to_login = String.contains?(conn.request_path, "login")
    logged_in = JustCi.Session.logged_in?(conn)

    if (!logged_in && !already_redirected_to_login && !registration_path) do
      redirect(conn, to: "/login")
    end

    conn
  end
end
