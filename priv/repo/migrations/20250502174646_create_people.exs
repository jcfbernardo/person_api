defmodule PersonApi.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :age, :integer
      add :email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
