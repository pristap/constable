defmodule Constable.UserSocket do
  use Phoenix.Socket
  require Logger

  alias Constable.Repo
  alias Constable.User

  channel "update", Constable.UpdateChannel
  channel "live-html", Constable.LiveHtmlChannel

  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    if user = user_with_token(token) do
      socket = assign(socket, :current_user, user)
      {:ok, socket}
    else
      {:error, "Unauthorized"}
    end
  end

  def connect(params, _socket) do
    Logger.debug "Expected socket params to have a 'token', got: #{inspect params}"
  end

  def id(_socket), do: nil

  defp user_with_token(token) do
    Repo.get_by!(User, token: token)
  end
end
