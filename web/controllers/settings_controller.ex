defmodule JustCi.SettingsController do
  use JustCi.Web, :controller
  alias JustCi.ThirdPartyKey

  def index(conn, _params) do
    keys = Repo.all(ThirdPartyKey)
    render(conn, "index.html", keys: keys)
  end

  def new_key(conn, _params) do
    changeset = ThirdPartyKey.changeset(%ThirdPartyKey{})
    render(conn, "key_form.html", %{changeset: changeset, action: settings_path(conn, :create_key)})
  end

  def create_key(conn, %{"third_party_key" => key_params}) do
    changeset = ThirdPartyKey.changeset(%ThirdPartyKey{}, key_params)

    case Repo.insert(changeset) do
      {:ok, _key} ->
        conn
        |> put_flash(:info, "Key created successfully.")
        |> redirect(to: settings_path(conn, :index))
      {:error, changeset} ->
        render(conn, "key_form.html", %{changeset: changeset, action: settings_path(conn, :create_key)})
    end
  end

  def delete_key(conn, %{"key_id" => key_id}) do
    key = Repo.get!(ThirdPartyKey, key_id)

    Repo.delete!(key)

    conn
    |> put_flash(:info, "Key deleted successfully.")
    |> redirect(to: settings_path(conn, :index))
  end
end
