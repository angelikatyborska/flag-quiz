defmodule FlagQuiz.Svg do
  def parse_file(content) do
    content = to_charlist(content)
    {doc, _rest} = :xmerl_scan.string(content)
    {:ok, doc}
  end

  def export_string(doc) do
    [doc]
    |> :xmerl.export_simple(:xmerl_xml)
    |> to_string()
    |> String.replace("<?xml version=\"1.0\"?>", "")
    |> Kernel.<>("\n")
  end

  def set_attribute_on_element_with_id(
        element = {:xmlElement, _, _, _, _, _, _, attrs, children, _, _, _},
        target_id,
        attribute_name,
        attribute_value
      ) do
    has_target_id? =
      Enum.any?(attrs, fn
        {:xmlAttribute, :id, _, _, _, _, _, _, value, _} ->
          to_string(value) == target_id

        _ ->
          false
      end)

    if has_target_id? do
      new_attr = {
        :xmlAttribute,
        attribute_name,
        [],
        [],
        [],
        [],
        0,
        [],
        to_charlist(attribute_value),
        false
      }

      updated_attrs = attrs ++ [new_attr]
      put_elem(element, 7, updated_attrs)
    else
      updated_children =
        Enum.map(children, fn
          {:xmlElement, _, _, _, _, _, _, _, _, _, _, _} = child ->
            set_attribute_on_element_with_id(child, target_id, attribute_name, attribute_value)

          other ->
            other
        end)

      put_elem(element, 8, updated_children)
    end
  end

  def set_attribute_on_element_with_id(other, _, _, _), do: other
end
