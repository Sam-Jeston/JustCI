defmodule JustCi.RegistrationController do
  use JustCi.Web, :controller
  alias JustCi.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case existing_users do
      {:ok} -> create_user(conn, user_params)
      {:error} ->
        changeset = User.changeset(%User{})

        conn
        |> put_flash(:info, "You can only have one account! Try resetting your password")
        |> render("new.html", changeset: changeset)
    end
  end

  defp existing_users do
    users = User |> Repo.all

    case length users do
      1 -> {:error}
      _ -> {:ok}
    end
  end

  defp create_user(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)

    case JustCi.Registration.create(changeset, JustCi.Repo) do
      {:ok, changeset} ->
        conn
        |> put_session(:current_user, changeset.id)
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end
end
