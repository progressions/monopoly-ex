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
      ],
      history: [],
    ]
  end

  defmodule Player do
    defstruct [
      :name,
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
        history: ["Game begins with Isaac, Darla!"],
        players: [%Monopoly.Player{name: "Isaac"},
         %Monopoly.Player{name: "Darla"}]}

  """
  @spec init(players: list) :: struct
  def init(players: player_names) do
    players = Enum.map(player_names, &(%Player{name: &1}))
    game = %Game{players: players}
    Enum.reduce(players, game, fn (player, game) ->
      assign_to_space(game, player.name, 0)
    end)
    |> log("Game begins with #{Enum.join(player_names, ", ")}!")
  end

  def log(game, message) do
    %Game{game | history: [message|game.history]}
  end

  def new do
    init(players: ["nayeon", "tzuyu", "momo"])
  end

  def advance_next_player(%Game{players: [first|tail]} = game) do
    %{game | players: List.flatten(tail, [first])}
  end

  def next_player(%Game{players: [first|_]}), do: first

  def roll_dice do
    :rand.uniform(6) + :rand.uniform(6)
  end

  def move_player(game, player, spaces: spaces) do
    from = find_player(game.board, player)
    to = destination_index(game.board, from, spaces)
    move_player(game, player, from: from, to: to)
  end
  def move_player(game, player, to: to) do
    from = find_player(game.board, player)
    move_player(game, player, from: from, to: to)
  end
  def move_player(game, player, from: from, to: to) do
    game
    |> Monopoly.remove_from_space(player, from)
    |> Monopoly.assign_to_space(player, to)
  end

  def space_at(game, index) do
    Enum.at(game.board, index)
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
    result = (index+spaces)
    if result > len-1 do
      result - len
    else
      result
    end
  end

  def find_player(board, player), do: find_player(board, player, 0)
  def find_player([space], player, index) do
    if player in space.players, do: index, else: nil
  end
  def find_player([space|tail], player, index) do
    if player in space.players, do: index, else: find_player(tail, player, index+1)
  end

  def assign_to_space(game, player, space) do
    board = List.update_at(game.board, space, fn (space) ->
      %{space | players: [player|space.players]}
    end)

    %{game | board: board}
  end

  def remove_from_space(game, player, space) do
    board = List.update_at(game.board, space, fn (space) ->
      %{space | players: List.delete(space.players, player)}
    end)
    %{game | board: board}
  end
end
