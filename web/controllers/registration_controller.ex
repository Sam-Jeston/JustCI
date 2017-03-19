defmodule JustCi.RegistrationController do
  use JustCi.Web, :controller
  alias JustCi.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case JustCi.Registration.create(changeset, JustCi.Repo) do
      {:ok, changeset} ->
        conn
          |> put_flash(:info, "Your account was created")
          |> redirect(to: "/")
      {:error, changeset} ->
        conn
          |> put_flash(:info, "Unable to create account")
          |> render("new.html", changeset: changeset)
    end
  end
end
