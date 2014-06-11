{$, $$$, ScrollView} = require 'atom'

module.exports =
class JsonFacetView extends ScrollView
  editorId = null
  @content: ->
    @div class: 'json-facet native-key-bindings', tabindex: -1

  initialize: (serializeState) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  constructor: (editorId) ->
    console.log 'editor id', editorId
    editorId = editorId.editorId
    super

    self = this

    getEditor = ->
      for editor in atom.workspace.getEditors()
        return editor if editor.id?.toString() is editorId.toString()
      null
    editor = getEditor()

    @subscribe this, 'core:move-up', => @scrollUp()
    @subscribe this, 'core:move-down', => @scrollDown()
    @subscribe editor.getBuffer(), 'changed', (val) ->
     try
       self.renderJSON JSON.parse(editor.buffer.getText())

  getTitle: ->
    "JSON"

  renderJSON: (jsonData) ->
    @html '<div class="json-facet native-key-bindings"></div>'

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

    if jsonData instanceof Array
      this.append array(jsonData)
    else
      this.append object(jsonData) # adds the entire object to the view
