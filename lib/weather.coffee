WeatherView = require './weather-view'
{CompositeDisposable} = require 'atom'

module.exports = Weather =
  weatherView: null
  subscriptions: null
  config:
    zipcode:
      type: 'string'
      default: '43201'

  consumeStatusBar: (statusBar) ->
    @statusBarTile = statusBar.addRightTile(item: @weatherView, priority: 100)

  activate: (state) ->
    console.info('weather activated')

    @weatherView = new WeatherView()
    @weatherView.initialize()

    @subscriptions = new CompositeDisposable

  deactivate: ->
    @subscriptions.dispose()
    @statusBarTile?.destroy()
    @statusBarTile = null
