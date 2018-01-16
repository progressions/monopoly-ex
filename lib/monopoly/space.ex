defmodule Monopoly.Space do
  alias Monopoly.{Log, Player, Space}

  defstruct [
    :name,
    type: :property
  ]

  def land_on(game, name, %Space{type: :income_tax} = space) do
    game
    |> Player.pay_money(name, 200)
    |> Log.log("#{name} lands on #{space.name}")
  end

  def land_on(game, name, space) do
    Log.log(game, "#{name} lands on #{space.name}")
  end

  def traverse(game, name, from, to) when to < from do
    game
    |> Player.add_money(name, 200)
    |> Log.log("#{name} passes Go, collects $200")
  end

  def traverse(game, _player, _, _), do: game
end
