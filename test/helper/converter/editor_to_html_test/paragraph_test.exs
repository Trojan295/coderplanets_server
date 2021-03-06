defmodule GroupherServer.Test.Helper.Converter.EditorToHTML.Paragraph do
  @moduledoc false

  use GroupherServerWeb.ConnCase, async: true

  alias Helper.Converter.EditorToHTML.Class
  alias Helper.Converter.EditorToHTML, as: Parser

  @root_class Class.article()

  describe "[paragraph block]" do
    @editor_json %{
      "time" => 1_567_250_876_713,
      "blocks" => [
        %{
          "type" => "paragraph",
          "data" => %{
            "text" => "paragraph content"
          }
        }
      ],
      "version" => "2.15.0"
    }
    @tag :wip
    test "paragraph parse should work" do
      {:ok, editor_string} = Jason.encode(@editor_json)
      {:ok, converted} = Parser.to_html(editor_string)

      viewer_class = @root_class["viewer"]
      assert converted == ~s(<div class="#{viewer_class}"><p>paragraph content</p></div>)
    end

    @editor_json %{
      "time" => 1_567_250_876_713,
      "blocks" => [
        %{
          "type" => "paragraph",
          "data" => %{
            "text" => []
          }
        }
      ],
      "version" => "2.15.0"
    }
    @tag :wip
    test "invalid paragraph should have invalid hint" do
      {:ok, editor_string} = Jason.encode(@editor_json)
      {:error, error} = Parser.to_html(editor_string)

      assert error == [
               %{block: "paragraph", field: "text", message: "should be: string", value: []}
             ]
    end
  end
end
