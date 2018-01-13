defmodule Monopoly do
  @moduledoc """
  Documentation for Monopoly.
  """

  defmodule Space do
    defstruct [
      :name,
      players: [],
    ]
  end

  defmodule Game do
    defstruct [
      players: [],
      board: [
        %Space{name: "Go"},
        %Space{name: "Mediterranean Ave"},
        %Space{name: "Baltic Ave"},
        %Space{name: "Vermont Ave"},
        %Space{name: "Connecticut Ave"},
      ]
    ]
  end

  defmodule Player do
    defstruct [
      :name
    ]
  end

  @doc """
  Initialize a new game with a set of players.

  ## Examples

      iex> Monopoly.init(players: ["Isaac", "Darla"])
      %Monopoly.Game{board: [%Monopoly.Space{name: "Go",
          players: ["Darla", "Isaac"]},
         %Monopoly.Space{name: "Mediterranean Ave", players: []},
         %Monopoly.Space{name: "Baltic Ave", players: []},
         %Monopoly.Space{name: "Vermont Ave", players: []},
         %Monopoly.Space{name: "Connecticut Ave", players: []}],
        players: [%Monopoly.Player{name: "Isaac"},
         %Monopoly.Player{name: "Darla"}]}

  """
  @spec init(players: list) :: struct
  def init(players: players) do
    players = Enum.map(players, &(%Player{name: &1}))
    game = %Game{players: players}
    Enum.reduce(players, game, fn (player, game) ->
      assign_to_space(game, player: player.name, space: 0)
    end)
  end

  def new do
    init(players: ["nayeon", "tzuyu", "momo"])
  end

  def advance_next_player(%Game{players: [first|tail]} = game) do
    %{game | players: List.flatten(tail, [first])}
  end

  def next_player(%Game{players: [first|_]}), do: first

  def move_player(game, player) do
    move_player(game, player, :rand.uniform(6))
    |> advance_next_player
  end

  def move_player(game, player, spaces) do
    index = find_player(game.board, player)
    destination_index = destination_index(game.board, index, spaces)
    remove_from_space(game, player: player, space: index)
    |> assign_to_space(player: player, space: destination_index)
  end

  def destination_index(board, index, spaces) do
    (index+spaces) - length(board)
  end

  def find_player([space|tail], player) do
    if player in space.players, do: 0, else: find_player(tail, player, 0)
  end
  def find_player([space], player, index) do
    if player in space.players, do: index, else: nil
  end
  def find_player([space|tail], player, index) do
    if player in space.players, do: index, else: find_player(tail, player, index+1)
  end

  def assign_to_space(game, player: player, space: space) do
    board = List.update_at(game.board, space, fn (space) ->
      %{space | players: [player|space.players]}
    end)

    %{game | board: board}
  end

  def remove_from_space(game, player: player, space: space) do
    board = List.update_at(game.board, space, fn (space) ->
      %{space | players: List.delete(space.players, player)}
    end)
    %{game | board: board}
  end
end
