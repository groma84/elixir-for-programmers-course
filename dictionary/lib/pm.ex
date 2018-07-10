defmodule Pm do
  def switched({a, b}) do
    {b, a}
  end

  def same(a, a) do
    true
  end

  def same(a, b) do
    false
  end
end
