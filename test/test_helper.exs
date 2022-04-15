ExUnit.start()

defmodule TestHelpers do

  def repeat_until(test_condition) do
    Enum.reduce_while(Stream.iterate(0, &(&1 + 1)), false, fn _, acc ->
      if test_condition.() do
        acc = true
        {:halt, acc}
      else
        {:cont, acc}
      end
    end)
  end
end
