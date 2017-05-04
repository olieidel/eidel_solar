defmodule EidelSolar.Piko.Meters do

  def parse(html) do
    html
    |> Floki.find("td[width=70]")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&(String.replace(&1, "&nbsp", "")))
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&parse_number/1)
    |> name_values()
  end

  defp parse_number("x x x"), do: nil
  defp parse_number(item) when is_binary(item) do
    case Integer.parse(item) do
      :error -> nil
      {int, ""} -> int
      {_intc, _} ->
        case Float.parse(item) do
          :error -> nil
          {fl, _} -> fl
        end
    end
  end

  defp name_values(values) do
    names = [:power_now, :energy_total, :energy_today,
             :dc1_u, :ac1_u, :dc1_i, :ac1_p,
             :dc2_u, :ac2_u, :dc2_i, :ac2_p,
             :ac3_u, :ac3_p]

    Enum.zip(names, values)
    |> Enum.into(%{})
  end
end
