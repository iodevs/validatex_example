defmodule Server.Validators do
  @moduledoc """
  A validators.
  """

  alias Validatex.{Validation, Validators}

  def validator_for(field) do
    Map.get(
      %{
        "id" => &id/1,
        "name" => &name/1,
        "surname" => &surname/1,
        "password" => &password/1,
        "conf_password" => &conf_password/1
        # "conf_password" => &password/1
      },
      field
    )
  end

  # Private

  @spec id(pos_integer()) :: Result.t(String.t(), String.t())
  defp id(value) do
    value |> Integer.to_string() |> Validators.integer("Id has to be positive integer!")
  end

  @spec name(String.t()) :: Result.t(String.t(), String.t())
  defp name(value) do
    min = 3
    max = 10

    [
      Validators.not_empty(value, "Name is required!"),
      value
      |> String.length()
      |> Kernel.to_string()
      |> Validators.in_range(
        min,
        max,
        "Lenght of name has to be at most #{min} and at least #{max}!"
      )
    ]
    |> Result.product()
    |> Result.map(&hd/1)
  end

  @spec surname(String.t()) :: Result.t(String.t(), String.t())
  defp surname(value) do
    max = 4

    [
      Validators.not_empty(value, "Surname is required!"),
      value
      |> String.length()
      |> Kernel.to_string()
      |> Validators.at_least(max, "Too short surname! Try to write 4 letters and more...")
    ]
    |> Result.product()
    |> Result.map(&hd/1)
  end

  @spec password(String.t()) :: Result.t(String.t(), String.t())
  defp password(pass) do
    min = 4

    [
      Validators.not_empty(pass, "Password is required!"),
      pass
      |> String.length()
      |> Kernel.to_string()
      |> Validators.greater_than(min, "Weak password! Password should be longer.")
    ]
    |> Result.product()
    |> Result.map(&hd/1)
  end

  @spec conf_password(Validation.field(any(), a)) :: (a -> Result.t(String.t(), a)) when a: var
  defp conf_password(pass) do
    &Validators.equal_to?(&1, pass, "The passwords don't match!")
  end
end
