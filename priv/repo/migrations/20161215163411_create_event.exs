defmodule EidelSolar.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :server_time, :integer
      add :time, :datetime
      add :name, :string

      timestamps()
    end

    create unique_index(:events, [:server_time])
    create unique_index(:events, [:time])
  end
end
