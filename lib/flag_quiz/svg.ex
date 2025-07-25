defmodule FlagQuiz.Svg do
  require Record
  Record.defrecord(:xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl"))
  Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  Record.defrecord(
    :xmlAttribute,
    Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  )

  @type t :: record(:xmlElement)

  def parse_string(content) do
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

  def set_attribute_on_element_with_id(element, target_id, attribute_name, attribute_value) do
    modified =
      do_set_attribute_on_element_with_id(element, target_id, attribute_name, attribute_value)

    if modified == element do
      raise RuntimeError,
            "Operation set_attribute_on_element_with_id on ##{target_id} (#{attribute_name}=#{attribute_value}) did not modify the element"
    end

    modified
  end

  defp do_set_attribute_on_element_with_id(
         xmlElement() = element,
         target_id,
         attribute_name,
         attribute_value
       ) do
    attrs = xmlElement(element, :attributes)
    children = xmlElement(element, :content)

    has_target_id? =
      Enum.any?(attrs, fn
        xmlAttribute(name: :id, value: value) ->
          to_string(value) == target_id

        _ ->
          false
      end)

    if has_target_id? do
      new_attr = xmlAttribute(name: attribute_name, value: to_charlist(attribute_value))

      updated_attrs =
        Enum.filter(attrs, fn
          xmlAttribute(name: ^attribute_name) ->
            false

          _ ->
            true
        end) ++ [new_attr]

      xmlElement(element, attributes: updated_attrs)
    else
      updated_children =
        Enum.map(children, fn
          xmlElement() = child ->
            do_set_attribute_on_element_with_id(child, target_id, attribute_name, attribute_value)

          other ->
            other
        end)

      xmlElement(element, content: updated_children)
    end
  end

  defp do_set_attribute_on_element_with_id(other, _, _, _), do: other

  def get_attribute_on_element_with_id(
        xmlElement() = element,
        target_id,
        attribute_name
      ) do
    attrs = xmlElement(element, :attributes)
    children = xmlElement(element, :content)

    has_target_id? =
      Enum.any?(attrs, fn
        xmlAttribute(name: :id, value: value) ->
          to_string(value) == target_id

        _ ->
          false
      end)

    if has_target_id? do
      Enum.find_value(attrs, fn
        xmlAttribute(name: ^attribute_name, value: value) ->
          value

        _ ->
          nil
      end)
    else
      Enum.find_value(children, fn
        xmlElement() = child ->
          get_attribute_on_element_with_id(child, target_id, attribute_name)

        _ ->
          nil
      end)
    end
  end

  def get_attribute_on_element_with_id(other, _, _), do: other

  @spec set_attribute_on_root_element(t(), atom, String.t()) :: t()
  def set_attribute_on_root_element(doc, attribute_name, attribute_value) do
    attrs = xmlElement(doc, :attributes)
    new_attr = xmlAttribute(name: attribute_name, value: to_charlist(attribute_value))

    updated_attrs =
      Enum.filter(attrs, fn
        xmlAttribute(name: ^attribute_name) ->
          false

        _ ->
          true
      end) ++ [new_attr]

    xmlElement(doc, attributes: updated_attrs)
  end

  @spec get_attribute_on_root_element(t(), atom()) :: nil | String.t()
  def get_attribute_on_root_element(xmlElement() = doc, attribute_name) do
    attrs = xmlElement(doc, :attributes)

    Enum.find_value(attrs, fn
      xmlAttribute(name: ^attribute_name, value: value) ->
        value |> to_string()

      _ ->
        nil
    end)
  end

  def number_to_string_number(x) do
    if is_float(x) do
      :erlang.float_to_binary(x, decimals: 2)
    else
      Integer.to_string(x)
    end
  end

  def string_number_to_number(x) do
    x |> Float.parse() |> elem(0)
  end
end
