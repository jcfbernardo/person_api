defmodule PersonApi.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PersonApi.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        age: 42,
        email: "some email",
        name: "some name"
      })
      |> PersonApi.People.create_person()

    person
  end
end
