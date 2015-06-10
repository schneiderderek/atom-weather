WeatherView = require './weather-view'
{CompositeDisposable} = require 'atom'

module.exports = Weather =
  weatherView: null
  subscriptions: null
  config:
    zipcode:
      type: 'integer'
      default: 43201
    updateInterval:
      type: 'integer'
      default: 15
    showIcon:
      type: 'boolean'
      default: true

  consumeStatusBar: (statusBar) ->
    @statusBarTile = statusBar.addRightTile(item: @weatherView, priority: 100)

  activate: (state) ->
    console.info('weather activated')

    @weatherView = new WeatherView()
    @weatherView.initialize()

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'weather:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @statusBarTile?.destroy()
    @statusBarTile = null

  toggle: ->
    if @weatherView.isVisible()
      @weatherView.hide()
    else
      @weatherView.show()
