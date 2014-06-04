{$, $$$, ScrollView} = require 'atom'

module.exports =
class JsonFacetView extends ScrollView
  @content: ->
    @div class: 'json-facet', =>

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
    string = (val) ->
      $("<span class='string'>#{val}</span>")
    number = (val) ->
      $("<span class='number'>#{val}</span>")
    boolean = (val) ->
      $("<span class='boolean'>#{val}</span>")
    nulll = ->
      $("<span class='null'>null</span>")
    array = (val) ->
      el = $("<div class='array'></div>")
      val.forEach (item) ->
        el.append value(item)
      return el
    object = (val) ->
      el = $("<div class='object'></div>")
      Object.keys(val).forEach (key) ->
        el.append pair(key, val[key])
      return el

    value = (val) ->
      if typeof val == 'number'
        return number(val)
      else if typeof val == 'string'
        return string(val)
      else if typeof val == 'boolean'
        return boolean(val)
      else if val instanceof Array
        return array(val)
      else if val instanceof Object
        return object(val)
      else
        return nulll()

    pair = (name, val) ->
      el = $("<div class=pair><span>#{name}</span></div>")
      el.append value(val)
      return el

    this.append object(jsonData)
