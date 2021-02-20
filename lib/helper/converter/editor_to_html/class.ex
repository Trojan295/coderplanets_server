defmodule Helper.Converter.EditorToHTML.Class do
  @moduledoc """
  html article class names parsed from editor.js's json data

  currently use https://editorjs.io/ as rich-text editor
  # NOTE: DONOT CHANGE ONCE SET, OTHERWISE IT WILL CAUSE INCOMPATIBILITY ISSUE
  """

  @doc """
  get all the class names of the parsed editor.js's html parts
  """
  def article() do
    %{
      # root wrapper
      "viewer" => "article-viewer-wrapper",
      "unknow_block" => "unknow-block",
      "invalid_block" => "invalid-block",
      # header
      "header" => %{
        "wrapper" => "header-wrapper",
        "eyebrow_title" => "eyebrow-title",
        "footer_title" => "footer-title"
      },
      # list
      "list" => %{
        "wrapper" => "list-wrapper",
        "item" => "list-item",
        "label" => "list-label",
        "label__default" => "list-label__default",
        "label__red" => "list-label__red",
        "label__green" => "list-label__green",
        "label__warn" => "list-label__warn",
        "checklist_item" => "list-checklist__item",
        "checklist_checkbox" => "checklist__item-checkbox",
        "checklist_checkbox_checked" => "checklist__item-check-sign-active",
        "checklist_checksign" => "checklist__item-check-sign",
        "text" => "list-item-text",
        "checklist_text" => "list-checklist__item-text"
      }
    }
  end
end
