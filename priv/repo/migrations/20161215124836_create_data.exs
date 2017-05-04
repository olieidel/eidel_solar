defmodule EidelSolar.Repo.Migrations.CreateData do
  use Ecto.Migration

  def change do
    create table(:data) do
      add :server_time, :integer
      add :time, :datetime
      add :dc1_u, :integer
      add :dc1_i, :integer
      add :dc1_p, :integer
      add :dc1_t, :integer
      add :dc1_s, :integer
      add :dc2_u, :integer
      add :dc2_i, :integer
      add :dc2_p, :integer
      add :dc2_t, :integer
      add :dc2_s, :integer
      add :dc3_u, :integer
      add :dc3_i, :integer
      add :dc3_p, :integer
      add :dc3_t, :integer
      add :dc3_s, :integer
      add :ac1_u, :integer
      add :ac1_i, :integer
      add :ac1_p, :integer
      add :ac1_t, :integer
      add :ac2_u, :integer
      add :ac2_i, :integer
      add :ac2_p, :integer
      add :ac2_t, :integer
      add :ac3_u, :integer
      add :ac3_i, :integer
      add :ac3_p, :integer
      add :ac3_t, :integer
      add :ac_f, :float
      add :fc_i, :integer
      add :ain1, :integer
      add :ain2, :integer
      add :ain3, :integer
      add :ain4, :integer
      add :ac_s, :integer
      add :err, :integer
      add :ens_s, :integer
      add :ens_err, :integer

      timestamps()
    end

    create unique_index(:data, [:server_time])
    create unique_index(:data, [:time])
  end
end
