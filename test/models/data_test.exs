defmodule EidelSolar.DataTest do
  use EidelSolar.ModelCase

  alias EidelSolar.Data

  @valid_attrs %{ain4: 42, dc2_u: 42, total_e: 42, dc3_i: 42, dc2_i: 42, ac_s: 42, ain2: 42, dc2_p: 42, event: "some content", dc1_t: 42, ac2_i: 42, ac1_i: 42, dc2_s: 42, dc3_s: 42, ain3: 42, dc2_t: 42, ac3_u: 42, dc1_p: 42, err: 42, dc1_i: 42, dc3_t: 42, ac1_u: 42, fc_i: 42, ac3_p: 42, ac3_t: 42, ac3_i: 42, ac2_p: 42, ac2_u: 42, ac1_p: 42, dc3_p: 42, ens_s: 42, dc1_u: 42, ac1_t: 42, kb_s: "some content", dc1_s: 42, dc3_u: 42, ac_f: "120.5", iso_r: 42, ens_err: 42, ac2_t: 42, ain1: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Data.changeset(%Data{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Data.changeset(%Data{}, @invalid_attrs)
    refute changeset.valid?
  end
end
