defmodule Monopoly do
  @moduledoc """
  Documentation for Monopoly.
  """

  alias Monopoly.{Game, Log, Player, Space}

  @doc """
  Initialize a new game with a set of players.

  ## Examples

  """
  @spec init(players: list) :: struct
  def init(players: player_names) do
    players = Enum.map(player_names, &{&1, %Player{name: &1}})

    %Game{players: players}
    |> Log.log("Game begins with #{Enum.join(player_names, ", ")}!")
  end

  def new do
    init(players: ["nayeon", "tzuyu", "momo"])
  end

  def advance_next_player(%Game{players: [first | tail]} = game) do
    %{game | players: List.flatten(tail, [first])}
  end

  def next_player(%Game{players: [first | _]}), do: first

  defp roll_dice do
    :rand.uniform(6) + :rand.uniform(6)
  end

  def space_at(game, index) do
    Enum.at(game.spaces, index)
  end

  @doc """
  Finds the player's destination after moving a given number of spaces along the board.

  Wraps around the board if necessary.

  ## Examples

      iex> Monopoly.destination_index([0,1,2,3,4,5], 1, 1)
      2

      iex> Monopoly.destination_index([0,1,2,3,4,5], 1, 4)
      5

      iex> Monopoly.destination_index([0,1,2,3,4,5], 1, 5)
      0

  """
  def destination_index(board, index, spaces) do
    len = length(board)
    result = index + spaces

    if result > len - 1 do
      result - len
    else
      result
    end
  end
end
