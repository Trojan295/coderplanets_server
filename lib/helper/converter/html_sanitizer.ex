defmodule Helper.Converter.HtmlSanitizer do
  @moduledoc """
  Sanitizer user input from editor.js or other
  content contains html tags
  see; http://katafrakt.me/2016/09/03/custom-rules-in-htmlsanitizeex/
  """
  defmodule Scrubber do
    @moduledoc false

    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    Meta.remove_cdata_sections_before_scrub()
    Meta.strip_comments()

    Meta.allow_tag_with_uri_attributes("a", ["href"], ["http", "https"])
    Meta.allow_tag_with_these_attributes("a", ["name", "title", "class"])

    # Meta.allow_tag_with_these_attributes("strong", [])
    # Meta.allow_tag_with_these_attributes("em", [])
    Meta.allow_tag_with_these_attributes("b", [])
    Meta.allow_tag_with_these_attributes("i", [])
    Meta.allow_tag_with_these_attributes("mark", ["class"])
    Meta.allow_tag_with_these_attributes("code", ["class"])
    Meta.allow_tag_with_these_attributes("pre", ["class"])
    # Meta.allow_tag_with_these_attributes("p", [])
    Meta.allow_tag_with_these_attributes("h1", ["class"])
    Meta.allow_tag_with_these_attributes("h2", ["class"])
    Meta.allow_tag_with_these_attributes("h3", ["class"])
    # Meta.allow_tag_with_these_attributes("h4", ["class"])
    # Meta.allow_tag_with_these_attributes("h5", ["class"])
    # Meta.allow_tag_with_these_attributes("h6", ["class"])
    Meta.allow_tag_with_these_attributes("p", ["class"])
    Meta.allow_tag_with_these_attributes("img", ["class", "src"])
    Meta.allow_tag_with_these_attributes("div", ["class"])
    Meta.allow_tag_with_these_attributes("ul", ["class"])
    Meta.allow_tag_with_these_attributes("ol", ["class"])
    Meta.allow_tag_with_these_attributes("li", ["class"])

    Meta.allow_tag_with_these_attributes("iframe", [
      "sandbox",
      "allow-same-origin",
      "allow-popups",
      "allow-presentation",
      "src",
      "frameborder",
      "allow",
      "allowfullscreen",
      "style"
    ])

    Meta.strip_everything_not_covered()
  end

  # 跳过一些 sanitize 很麻烦的标签，比如 svg data
  def sanitize({:skip_sanitize, html}), do: html

  def sanitize(html) when is_binary(html) do
    html |> HtmlSanitizeEx.Scrubber.scrub(Scrubber)
  end
end
