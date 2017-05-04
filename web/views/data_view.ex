defmodule EidelSolar.DataView do
  use EidelSolar.Web, :view

  def render("index.json", %{data: data}) do
    %{data: render_many(data, EidelSolar.DataView, "data.json")}
  end

  def render("data.json", %{data: data}) do
    %{id: data.id,
      server_time: data.server_time,
      time: data.time,
      dc1_u: data.dc1_u,
      dc1_i: data.dc1_i,
      dc1_p: data.dc1_p,
      dc1_t: data.dc1_t,
      dc1_s: data.dc1_s,
      dc2_u: data.dc2_u,
      dc2_i: data.dc2_i,
      dc2_p: data.dc2_p,
      dc2_t: data.dc2_t,
      dc2_s: data.dc2_s,
      dc3_u: data.dc3_u,
      dc3_i: data.dc3_i,
      dc3_p: data.dc3_p,
      dc3_t: data.dc3_t,
      dc3_s: data.dc3_s,
      ac1_u: data.ac1_u,
      ac1_i: data.ac1_i,
      ac1_p: data.ac1_p,
      ac1_t: data.ac1_t,
      ac2_u: data.ac2_u,
      ac2_i: data.ac2_i,
      ac2_p: data.ac2_p,
      ac2_t: data.ac2_t,
      ac3_u: data.ac3_u,
      ac3_i: data.ac3_i,
      ac3_p: data.ac3_p,
      ac3_t: data.ac3_t,
      ac_f: data.ac_f,
      fc_i: data.fc_i,
      ain1: data.ain1,
      ain2: data.ain2,
      ain3: data.ain3,
      ain4: data.ain4,
      ac_s: data.ac_s,
      err: data.err,
      ens_s: data.ens_s,
      ens_err: data.ens_err}
  end
end
