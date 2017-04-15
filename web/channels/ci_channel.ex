defmodule JustCi.CiChannel do
  use Phoenix.Channel

  # TODO: Add authorization to the join
  def join("ci:lobby", _message, socket) do
    {:ok, socket}
  end

  # TODO: We'll actually want to use a private channel for each user
  def join("ci:" <> _build_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
