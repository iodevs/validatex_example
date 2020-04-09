defmodule ServerWeb.HeaderLive do
  @moduledoc false
  use ServerWeb, :live


  def mount(_params, _session, socket) do
      {:ok, socket}
  end

  def render(assigns), do: ServerWeb.LayoutView.render("header.html", assigns)

  end
