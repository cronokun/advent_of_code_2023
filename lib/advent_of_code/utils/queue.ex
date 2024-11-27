defmodule AdventOfCode.Utils.Queue do
  @moduledoc "Simple implementation of priority queue based on Heap."

  defstruct [:queue]

  def new do
    %__MODULE__{
      queue: Heap.new(fn a, b -> elem(a, 0) <= elem(b, 0) end)
    }
  end

  def enqueue(pqueue, elements) when is_list(elements) do
    Enum.reduce(elements, pqueue, fn e, q -> put(q, e) end)
  end

  def put(pqueue, element) do
    %{pqueue | queue: Heap.push(pqueue.queue, element)}
  end

  def pop(pqueue) do
    {element, queue} = Heap.split(pqueue.queue)
    {element, %{pqueue | queue: queue}}
  end
end
