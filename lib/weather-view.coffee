WeatherData = require './weather-data'

class WeatherView extends HTMLElement
  configRerenderTriggers: ['zipcode', 'showIcon', 'showHumidity', 'showHigh', 'showLow', 'showTemp', 'showSunrise', 'showSunset']
  configResponseMappings:
    showTemp:
      suffix: 'F'
      dataAttribute: 'temp'
    showHumidity:
      suffix: '%'
      dataAttribute: 'humidity'
    showLow:
      suffix: 'F'
      prefix: 'L'
      dataAttribute: 'low'
    showHigh:
      suffix: 'F'
      prefix: 'H'
      dataAttribute: 'high'
    showSunrise:
      dataAttribute: 'sunrise'
    showSunset:
      dataAttribute: 'sunset'
  data: null
  initialize: ->
    @classList.add('weather', 'inline-block')

    @content = document.createElement('div')
    @content.classList.add('weather-content')

    @appendChild(@content)

    @data = new WeatherData(@showWeather.bind(@))

    @showLoading()

    for optionName in @configRerenderTriggers
      atom.config.onDidChange "weather.#{optionName}", @data.refresh.bind(@data)

  isVisible: ->
    @classList.contains('hidden')

  show: ->
    @classList.add('hidden')

  hide: ->
    @classList.remove('hidden')

  showLoading: ->
    @content.innerText = "Getting weather for: #{@data.zipcode()}"

  showError: (errorText) ->
    @content.innerText = "Cannot load weather: #{errorText}"

  iconUrl: (iconName) ->
    "http://openweathermap.org/img/w/#{iconName}.png"

  showIcon: ->
    return unless atom.config.get('weather.showIcon') && @data.iconCode?

    img = document.createElement('img')
    img.setAttribute('src', @iconUrl(@data.iconCode))
    @content.appendChild(img)

  formatString: (configName) ->
    config = @configResponseMappings[configName]
    data = @data[config.dataAttribute]
    return '' unless data
    "#{config.prefix || ''}#{data}#{config.suffix || ''}"

  showWeather: () ->
    @content.innerHTML = ''

    @showIcon()
    info = []

    for configName in Object.keys(@configResponseMappings)
      if atom.config.get "weather.#{configName}"
        info.push @formatString(configName)

    @content.appendChild document.createTextNode(info.join ' ')


module.exports = document.registerElement('status-bar-weather',
                                          prototype: WeatherView.prototype,
                                          extends: 'div')
