defmodule ServerWeb.User.NewLive do
  @moduledoc false
  use ServerWeb, :live

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns), do: ServerWeb.UserView.render("new.html", assigns)

  def handle_params(
        %{
          "name" => name,
          "surname" => surname
        },
        _uri,
        socket
      ) do
    socket =
      socket
      |> assign(name: name)
      |> assign(surname: surname)

    {:noreply, socket}
  end
end
