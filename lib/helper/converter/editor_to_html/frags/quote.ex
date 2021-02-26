defmodule Helper.Converter.EditorToHTML.Frags.Quote do
  @moduledoc """
  parse editor.js's block fragments, use for test too

  see https://editorjs.io/
  """
  import Helper.Validator.Guards, only: [g_none_empty_str: 1]

  alias Helper.Types, as: T
  alias Helper.Converter.EditorToHTML.Class

  @class get_in(Class.article(), ["quote"])

  @spec get(T.editor_quote()) :: T.html()
  def get(%{"mode" => "short", "text" => text}) do
    wrapper_class = @class["short_wrapper"]
    text_class = @class["text"]

    ~s(<blockquote class="#{wrapper_class}">
        <div class="#{text_class}">#{text}</div>
      </blockquote>)
  end

  def get(%{"mode" => "long", "text" => text, "caption" => caption})
      when g_none_empty_str(caption) do
    wrapper_class = @class["long_wrapper"]
    text_class = @class["text"]

    caption = frag(:caption, caption)

    ~s(<blockquote class="#{wrapper_class}">
        <div class="#{text_class}">#{text}</div>
        #{caption}
      </blockquote>)
  end

  def get(%{"mode" => "long", "text" => text}) do
    wrapper_class = @class["long_wrapper"]
    text_class = @class["text"]

    ~s(<blockquote class="#{wrapper_class}">
        <div class="#{text_class}">#{text}</div>
      </blockquote>)
  end

  def frag(:caption, caption) do
    caption_class = @class["caption"]
    caption_line_class = @class["caption_line"]
    caption_text_class = @class["caption_text"]

    ~s(<div class="#{caption_class}">
      <div class="#{caption_line_class}"/>
      <div class="#{caption_text_class}">#{caption}</div>
      </div>)
  end
end
