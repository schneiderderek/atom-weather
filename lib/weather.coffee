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
    showHumidity:
      type: 'boolean'
      default: true
    showHigh:
      type: 'boolean'
      default: true
    showLow:
      type: 'boolean'
      default: true
    showTemp:
      type: 'boolean'
      default: true
    showSunrise:
      type: 'boolean'
      default: true
    showSunset:
      type: 'boolean'
      default: true
    showPressure:
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
    @subscriptions.add atom.commands.add 'atom-workspace', 'weather:refresh': => @weatherView.refresh()

  deactivate: ->
    @subscriptions.dispose()
    @statusBarTile?.destroy()
    @statusBarTile = null

  toggle: ->
    if @weatherView.isVisible()
      @weatherView.hide()
    else
      @weatherView.show()
