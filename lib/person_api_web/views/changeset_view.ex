defmodule PersonApiWeb.ChangesetView do
  use Phoenix.View,
    root: "lib/person_api_web",
    namespace: PersonApiWeb

  import PersonApiWeb.ErrorHelpers

  def render("error.json", %{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end
end
