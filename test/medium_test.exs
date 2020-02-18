defmodule MediumTest do
  use ExUnit.Case
  doctest Medium

  test "greets the world" do
    assert Medium.hello() == :world
  end
end
