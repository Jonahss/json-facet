{$, $$$, ScrollView} = require 'atom'

module.exports =
class JsonFacetView extends ScrollView
  @content: ->
    @div class: 'json-facet', =>
      @div "hi", class: "message"

  initialize: (serializeState) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  constructor: (editorId) ->
    console.log 'editor id', editorId
    super

    getEditor: () ->
      for editor in atom.workspace.getEditors()
        return editor if editor.id?.toString() is editorId.toString()
      null

  getTitle: ->
    "JSON"

  renderJSON: (jsonData) ->
    subItem = (name, val) ->
      if name
        data = $('<div>#{name}</div>')
      else
        data = $('<div></div>')

      if val == null
        data.append($('<div>null</div>'))
      else if val instanceof Array
        val.forEach (item) ->
          data.append($('<div>#{item}</div>'))
      else if val instanceof Object
        Object.keys(val).forEach (key) ->
          data.append(subItem(key, val[key]))
      else
        data.append($('<div>#{val}</div>'))

      return data

    Object.keys(jsonData).forEach (key) ->
      this.append(subItem(key, jsonData[key]))
