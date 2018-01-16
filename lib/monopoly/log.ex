defmodule Monopoly.Log do
  def log(game, message) do
    %{game | history: [message | game.history]}
  end
end
