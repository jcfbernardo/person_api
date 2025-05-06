defmodule PersonApiWeb.PersonJSON do
  alias PersonApi.People.Person

  @doc """
  Renders a list of people.
  """
  def index(%{people: people}) do
    %{data: for(person <- people, do: data(person))}
  end

  @doc """
  Renders a single person.
  """
  def show(%{person: person}) do
    %{data: data(person)}
  end

  defp data(%Person{} = person) do
    %{
      id: person.id,
      name: person.name,
      age: person.age,
      email: person.email
    }
  end
end
