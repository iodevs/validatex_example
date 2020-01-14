defmodule ServerWeb.User.RegisterLive do
  @moduledoc false
  use ServerWeb, :live

  alias Server.Validators
  alias ServerWeb.User.Helpers
  alias Validatex.{MapExtra, Validation}

  require Logger

  def mount(_session, socket) do
    socket =
      socket
      |> assign(user: new_user())

    {:ok, socket}
  end

  def render(assigns) do
    ServerWeb.RegisterView.render(
      "register.html",
      assigns
      |> Map.put(:btn_label, "Sign up")
      |> Map.put(
        :style_width_error,
        Helpers.get_width_error(assigns.user, ["name", "surname", "password", "conf_password"])
      )
    )
  end

  def handle_event(
        "on_change",
        %{"_target" => ["user", "password"], "user" => data},
        %{assigns: %{user: user}} = socket
      ) do
    user =
      user
      |> Validation.validate_on_change(
        "password",
        MapExtra.get!(data, "password"),
        Validators.validator_for("password")
      )
      |> Validation.validate_on_related_change(
        "conf_password",
        "password",
        Validators.validator_for("conf_password")
      )

    {:noreply,
     assign(
       socket,
       :user,
       user
     )}
  end

  def handle_event(
        "on_change",
        %{"_target" => ["user", "conf_password"], "user" => data},
        %{assigns: %{user: user}} = socket
      ) do
    {:noreply,
     assign(
       socket,
       :user,
       Validation.validate_on_change(
         user,
         "conf_password",
         MapExtra.get!(data, "conf_password"),
         Validators.validator_for("conf_password").(user["password"])
       )
     )}
  end

  def handle_event(
        "on_blur",
        %{"field" => "conf_password"},
        %{assigns: %{user: user}} = socket
      ) do
    {:noreply,
     assign(
       socket,
       :user,
       Validation.validate_on_blur(
         user,
         "conf_password",
         Validators.validator_for("conf_password").(user["password"])
       )
     )}
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
         MapExtra.get!(data, field),
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
    user =
      user
      |> Validation.validate_on_submit("name", Validators.validator_for("name"))
      |> Validation.validate_on_submit("surname", Validators.validator_for("surname"))
      |> Validation.validate_on_submit("password", Validators.validator_for("password"))
      |> Validation.validate_on_related_submit(
        "conf_password",
        "password",
        Validators.validator_for("conf_password")
      )

    case Validation.submit_if_valid(
           user,
           ["name", "surname", "password", "conf_password"],
           #  &CreateUser.add_new/1
           fn user ->
             Logger.info(fn -> "CREATED USER: #{inspect(user)}" end)
             Result.ok(user)
           end
         ) do
      {:ok, _} ->
        {:noreply,
         live_redirect(socket,
           to: Routes.live_path(socket, ServerWeb.User.NewLive, raw_user_data(user))
         )}

      _ ->
        {:noreply, assign(socket, user: user)}
    end
  end

  # Private

  defp new_user() do
    %{
      "name" => Validation.field(""),
      "surname" => Validation.field(""),
      "password" => Validation.field(""),
      "conf_password" => Validation.field("")
    }
  end

  defp raw_user_data(user) do
    user
    |> Enum.map(fn {k, v} -> {k, Validation.raw_value(v)} end)
    |> Map.new()
  end
end
