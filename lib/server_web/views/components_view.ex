defmodule ServerWeb.ComponentsView do
  use ServerWeb, :view

  def add_warning_style_if_field_has([]) do
    "input"
  end

  def add_warning_style_if_field_has(_) do
    "input is-danger"
  end

  def add_width_for(num) when is_integer(num) do
    "errors #{width_for(num)}"
  end

  # Private

  defp width_for(0), do: ""

  defp width_for(w) when 0 < w and w < 15 do
    "error-width-120"
  end

  defp width_for(w) when 15 < w and w < 65 do
    "error-width-220"
  end

  defp width_for(w) when 65 < w do
    "has-max-width-250-desktop"
  end
end
