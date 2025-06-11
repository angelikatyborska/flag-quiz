defmodule FlagQuiz.Flag.ModificationTest do
  use ExUnit.Case
  alias FlagQuiz.Flag.Modification

  test "generate_combination" do
    all = [
      %Modification{id: :one, tweaks: []},
      %Modification{id: :two, tweaks: []},
      %Modification{id: :three, tweaks: []}
    ]

    conflicts = [{:one, :three}]

    assert Modification.generate_combinations(all, conflicts) == [
             [%Modification{id: :one, tweaks: []}],
             [%Modification{id: :two, tweaks: []}],
             [%Modification{id: :three, tweaks: []}],
             [%Modification{id: :one, tweaks: []}, %Modification{id: :two, tweaks: []}],
             [%Modification{id: :two, tweaks: []}, %Modification{id: :three, tweaks: []}]
           ]
  end

  describe "generate_id_combinations" do
    test "1 item, no conflicts" do
      all = [:one]
      conflicts = []

      assert Modification.generate_id_combinations(all, conflicts) == [
               [:one]
             ]
    end

    test "2 items, no conflicts" do
      all = [:one, :two]
      conflicts = []

      assert Modification.generate_id_combinations(all, conflicts) == [
               [:one],
               [:two],
               [:one, :two]
             ]
    end

    test "3 items, no conflicts" do
      all = [:one, :two, :three]
      conflicts = []

      assert Modification.generate_id_combinations(all, conflicts) == [
               [:one],
               [:two],
               [:three],
               [:one, :two],
               [:one, :three],
               [:two, :three],
               [:one, :two, :three]
             ]
    end

    test "3 items, one conflict" do
      all = [:one, :two, :three]
      conflicts = [{:one, :three}]

      assert Modification.generate_id_combinations(all, conflicts) == [
               [:one],
               [:two],
               [:three],
               [:one, :two],
               [:two, :three]
             ]
    end

    test "4 items, no conflicts" do
      all = [:one, :two, :three, :four]
      conflicts = []

      assert Modification.generate_id_combinations(all, conflicts) == [
               [:one],
               [:two],
               [:three],
               [:four],
               [:one, :two],
               [:one, :three],
               [:one, :four],
               [:two, :three],
               [:two, :four],
               [:three, :four],
               [:one, :two, :three],
               [:one, :two, :four],
               [:one, :three, :four],
               [:two, :three, :four],
               [:one, :two, :three, :four]
             ]
    end

    test "4 items, two conflicts" do
      all = [:one, :two, :three, :four]
      conflicts = [{:one, :two}, {:two, :four}]

      assert Modification.generate_id_combinations(all, conflicts) == [
               [:one],
               [:two],
               [:three],
               [:four],
               [:one, :three],
               [:one, :four],
               [:two, :three],
               [:three, :four],
               [:one, :three, :four]
             ]
    end
  end
end
