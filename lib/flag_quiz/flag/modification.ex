defmodule FlagQuiz.Flag.Modification do
  defstruct [:id, :tweaks]

  @type id :: atom
  @type t :: %__MODULE__{
          # modification id should be:
          # - human-readable
          # - unique for modifications of the same flag
          # - repeated for different flag if it describes the same concept, e.g. swapping colors 1 and 3 on a tricolor flag
          id: id,
          tweaks: [FlagQuiz.Flag.Tweak.t()]
        }

  @spec generate_combinations([atom], [{atom, atom}]) :: [[atom]]
  def generate_combinations(all, conflicting_pairs) do
    do_generate_combinations(all)
    |> Enum.sort_by(fn {length, _values} -> length end)
    |> Enum.reverse()
    |> Enum.reduce([], fn {_length, values}, acc -> values ++ acc end)
    |> do_filter_conflicting_pairs(conflicting_pairs)
  end

  defp do_generate_combinations(all) when length(all) == 0 do
    %{0 => []}
  end

  defp do_generate_combinations(all) when length(all) == 1 do
    %{1 => [[hd(all)]]}
  end

  defp do_generate_combinations(all) when length(all) >= 2 do
    [item | rest] = all

    combinations = do_generate_combinations(rest)

    max = length(all)

    max..1//-1
    |> Enum.reduce(combinations, fn length, acc ->
      new_combinations =
        Enum.map(Map.get(combinations, length - 1, [[]]), fn combination ->
          [item | combination]
        end)

      Map.update(acc, length, new_combinations, fn old_combinations_of_same_length ->
        new_combinations ++ old_combinations_of_same_length
      end)
    end)
  end

  defp do_filter_conflicting_pairs(combinations, conflicting_pairs) do
    combinations
    |> Enum.reject(fn combination ->
      conflicting_pairs
      |> Enum.find(fn pair ->
        elem(pair, 0) in combination and elem(pair, 1) in combination
      end)
    end)
  end
end
