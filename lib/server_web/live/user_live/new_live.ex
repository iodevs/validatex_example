defmodule ServerWeb.User.NewLive do
  @moduledoc false
  use ServerWeb, :live

  alias Server.Validators
  alias ServerWeb.User.Helpers
  alias Validatex.Validation

  def mount(_session, socket) do
    socket =
      socket
      |> assign(user: new_user())

    {:ok, socket}
  end

  def render(assigns) do
    ServerWeb.UserView.render(
      "new.html",
      assigns
      |> Map.put(:btn_label, "Add user")
      |> Map.put(
        :style_width_error,
        Helpers.get_width_error(assigns.user, ["name", "surname", "score"])
      )
    )
  end

  def handle_event(
        "on_change",
        %{"_target" => ["user", field], "user" => data},
        %{assigns: %{user: user}} = socket
      ) do
    {:noreply,
     assign(
       socket,
       :user,
       Validation.validate_on_change(
         user,
         field,
         Helpers.get!(data, field),
         Validators.validator_for(field)
       )
     )}
  end

  def handle_event(
        "on_blur",
        %{"field" => field},
        %{assigns: %{user: user}} = socket
      ) do
    {:noreply,
     assign(
       socket,
       :user,
       Validation.validate_on_blur(user, field, Validators.validator_for(field))
     )}
  end

  def handle_event("add_user", _params, %{assigns: %{user: user}} = socket) do
    user = Validation.validate_on_submit(user, &Validators.validator_for/1)

    case Validation.submit_if_valid(
           user,
           ["name", "surname", "score"],
           #  &CreateUser.add_new/1
           fn _ -> IO.puts("User was created") end
         ) do
      {:ok, _user} ->
        {:noreply, assign(socket, user: new_user())}

      _ ->
        {:noreply, assign(socket, user: user)}
    end
  end

  defp new_user() do
    %{
      "name" => Validation.field(""),
      "surname" => Validation.field(""),
      "score" => Validation.optional_field("")
    }
  end
end
