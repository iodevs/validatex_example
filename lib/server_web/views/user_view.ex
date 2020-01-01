defmodule ServerWeb.UserView do
  use ServerWeb, :view

  import ServerWeb.User.Helpers, only: [extract_error_or_errors: 1]
  import Validatex.Validation, only: [raw_value: 1]
end
