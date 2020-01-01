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
        "score" => Validation.optional(&score/1)
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
        "Name has to be at most #{min} and at least #{max} lenght!"
      )
    ]
    |> Result.product()
    |> Result.map(&hd/1)
  end

  @spec surname(String.t()) :: Result.t(String.t(), String.t())
  defp surname(value) do
    min = 5
    max = 10

    [
      Validators.not_empty(value, "Surname is required!"),
      value
      |> String.length()
      |> Kernel.to_string()
      |> Validators.at_least(min, "Surname has to be at most #{min} lenght!")
    ]
    |> Result.product()
    |> Result.map(&hd/1)
  end

  @spec score(String.t()) :: Result.t(String.t(), String.t())
  defp score(value) do
    {:ok, value}
  end
end
