defmodule ServerWeb.User.Helpers do
  @moduledoc """
  A user live view helpers
  """

  # alias Model.Validators
  alias Validatex.Validation
  import Validatex.Validation, only: [key?: 1]

  @spec extract_error_or_errors(Validation.field(any(), any())) :: [String.t()]
  def extract_error_or_errors(field) do
    field
    |> Validation.extract_error()
    |> binary_to_list_of_binaries()
  end

  @spec get_width_error(map(), list(Validation.key())) :: pos_integer()
  def get_width_error(user, field_list) when is_list(field_list) do
    user
    |> collect_all_errors_from(field_list)
    |> get_max()
  end

  @spec collect_all_errors_from(map(), [Validation.key()]) :: [String.t()]
  def collect_all_errors_from(user, field_list) when is_list(field_list) do
    field_list
    |> Enum.map(fn field -> extract_error_or_errors(user[field]) end)
    |> List.flatten()
    |> Enum.uniq()
  end

  def get!(map, key) when is_map(map) and key?(key) do
    Map.get(map, key) || raise "Key '#{key}' not found in '#{inspect(map)}'."
  end

  # Private

  defp get_max(errors) when is_list(errors) and 0 < length(errors) do
    errors
    |> Enum.map(&String.length/1)
    |> Enum.max()
  end

  defp get_max(_) do
    0
  end

  defp binary_to_list_of_binaries(nil) do
    []
  end

  defp binary_to_list_of_binaries(value) when is_binary(value) do
    [value]
  end

  defp binary_to_list_of_binaries(value) when is_list(value) do
    value
  end
end
