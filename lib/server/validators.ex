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
    Validators.not_empty(value, "Name is required!")
  end

  @spec surname(String.t()) :: Result.t(String.t(), String.t())
  defp surname(value) do
    Validators.not_empty(value, "Surname is required!")
  end

  @spec score(String.t()) :: Result.t(String.t(), String.t())
  defp score(value) do
    {:ok, value}
  end
end
