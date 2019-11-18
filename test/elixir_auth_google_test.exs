defmodule ElixirAuthGoogleTest do
  use ExUnit.Case
  doctest ElixirAuthGoogle

  test "greets the world" do
    assert ElixirAuthGoogle.hello() == :world
  end
end
