defmodule EidelSolar.Event do
  use EidelSolar.Web, :model

  schema "events" do
    field :server_time, :integer
    field :time, Ecto.DateTime
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:server_time, :time, :name])
    |> validate_required([:server_time, :time, :name])
    |> unique_constraint(:time)
    |> unique_constraint(:server_time)
  end
end
