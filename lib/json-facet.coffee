JsonFacetView = require './json-facet-view'
url = require 'url'

module.exports =
  jsonFacetView: null

  activate: (state) ->
    atom.workspaceView.command "json-facet:toggle", => @toggle()

    atom.workspace.registerOpener (uriToOpen) ->
      console.log 'uri to open', uriToOpen
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        console.log error
        return

      console.log protocol, host, pathname
      return unless protocol is 'json-facet:'

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        console.log error
        return
      console.log 'host is', host
      if host is 'editor'
        new JsonFacetView(editorId: pathname.substring(1))
      else
        new JsonFacetView(filePath: pathname)

  deactivate: ->
    @jsonFacetView.destroy()

  serialize: ->
    jsonFacetViewState: @jsonFacetView.serialize()

  toggle: ->
    console.log "JsonFacetView was toggled!"
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    uri = "json-facet://editor/#{editor.id}"

    previewPane = atom.workspace.paneForUri(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForUri(uri))
      return

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (jsonFacetView) ->
      if jsonFacetView instanceof JsonFacetView
        var text = editor.buffer.getText()     # gets text in file
        var JSONdata = JSON.parse(text)        # gets text as a javascript object
        jsonFacetView.renderJSON(JSONdata)     # sends to the view
        previousActivePane.activate()
