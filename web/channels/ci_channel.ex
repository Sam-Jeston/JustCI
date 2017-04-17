defmodule JustCi.CiChannel do
  use Phoenix.Channel

  def join("ci:lobby", _message, socket) do
    {:ok, socket}
  end

  # TODO: Once we authorize users against the builds they own, we will need to
  # use some authentication work here
  def join("ci:" <> buildJobIdentifier, _params, socket) do
    {:ok, socket}
  end
end
