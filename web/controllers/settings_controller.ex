defmodule JustCi.SettingsController do
  use JustCi.Web, :controller
  alias JustCi.ThirdPartyKey

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_key(conn, _params) do
    changeset = ThirdPartyKey.changeset(%ThirdPartyKey{})
    render(conn, "key_form.html", %{changeset: changeset, action: settings_path(conn, :create_key)})
  end

  def create_key(conn, %{"third_party_key" => key_params}) do
    changeset = ThirdPartyKey.changeset(%ThirdPartyKey{}, %{
      entity: "github",
      key: key_params["key"]
    })

    case Repo.insert(changeset) do
      {:ok, _key} ->
        conn
        |> put_flash(:info, "Key created successfully.")
        |> redirect(to: settings_path(conn, :index))
      {:error, changeset} ->
        render(conn, "key_form.html", %{changeset: changeset, action: settings_path(conn, :create_key)})
    end
  end
end
