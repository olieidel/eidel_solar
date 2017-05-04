defmodule EidelSolar.Data do
  use EidelSolar.Web, :model

  schema "data" do
    field :server_time, :integer
    field :time, Ecto.DateTime
    field :dc1_u, :integer
    field :dc1_i, :integer
    field :dc1_p, :integer
    field :dc1_t, :integer
    field :dc1_s, :integer
    field :dc2_u, :integer
    field :dc2_i, :integer
    field :dc2_p, :integer
    field :dc2_t, :integer
    field :dc2_s, :integer
    field :dc3_u, :integer
    field :dc3_i, :integer
    field :dc3_p, :integer
    field :dc3_t, :integer
    field :dc3_s, :integer
    field :ac1_u, :integer
    field :ac1_i, :integer
    field :ac1_p, :integer
    field :ac1_t, :integer
    field :ac2_u, :integer
    field :ac2_i, :integer
    field :ac2_p, :integer
    field :ac2_t, :integer
    field :ac3_u, :integer
    field :ac3_i, :integer
    field :ac3_p, :integer
    field :ac3_t, :integer
    field :ac_f, :float
    field :fc_i, :integer
    field :ain1, :integer
    field :ain2, :integer
    field :ain3, :integer
    field :ain4, :integer
    field :ac_s, :integer
    field :err, :integer
    field :ens_s, :integer
    field :ens_err, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:server_time, :time, :dc1_u, :dc1_i, :dc1_p, :dc1_t, :dc1_s, :dc2_u, :dc2_i, :dc2_p, :dc2_t, :dc2_s, :dc3_u, :dc3_i, :dc3_p, :dc3_t, :dc3_s, :ac1_u, :ac1_i, :ac1_p, :ac1_t, :ac2_u, :ac2_i, :ac2_p, :ac2_t, :ac3_u, :ac3_i, :ac3_p, :ac3_t, :ac_f, :fc_i, :ain1, :ain2, :ain3, :ain4, :ac_s, :err, :ens_s, :ens_err])
    |> validate_required([:server_time, :time, :dc1_u, :dc1_i, :dc1_p, :dc1_t, :dc1_s, :dc2_u, :dc2_i, :dc2_p, :dc2_t, :dc2_s, :dc3_u, :dc3_i, :dc3_p, :dc3_t, :dc3_s, :ac1_u, :ac1_i, :ac1_p, :ac1_t, :ac2_u, :ac2_i, :ac2_p, :ac2_t, :ac3_u, :ac3_i, :ac3_p, :ac3_t, :ac_f, :fc_i, :ain1, :ain2, :ain3, :ain4, :ac_s, :err, :ens_s, :ens_err])
    |> unique_constraint(:time)
    |> unique_constraint(:server_time)
  end
end
