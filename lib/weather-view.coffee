WeatherData = require './weather-data'

class WeatherView extends HTMLElement
  configRerenderTriggers: [
    'units', 'showIcon', 'showHumidity', 'showHigh', 'showLow', 'showTemp',
    'showSunrise', 'showSunset', 'showHumidity', 'showPressure', 'showWindSpeed',
    'showWindDirection']
  configRefreshTriggers: ['units', 'locationMethod']
  configResponseMappings:
    showTemp:
      unit:
        metric: 'C'
        imperial: 'F'
      dataAttribute: 'temp'
    showHumidity:
      suffix: '%'
      dataAttribute: 'humidity'
    showLow:
      unit:
        metric: 'C'
        imperial: 'F'
      prefix: 'L'
      dataAttribute: 'low'
    showHigh:
      unit:
        metric: 'C'
        imperial: 'F'
      prefix: 'H'
      dataAttribute: 'high'
    showSunrise:
      dataAttribute: 'sunrise'
    showSunset:
      dataAttribute: 'sunset'
    showPressure:
      suffix: 'hPa'
      dataAttribute: 'pressure'
    showWindSpeed:
      dataAttribute: 'windSpeed'
      unit:
        metric: 'MPS'
        imperial: 'MPH'
    showWindDirection:
      dataAttribute: 'windDirection'
  data: null
  initialize: ->
    @classList.add('weather', 'inline-block')

    @content = document.createElement('div')
    @content.classList.add('weather-content')

    @appendChild(@content)

    @data = new WeatherData(@showWeather.bind(@))

    @showLoading()

    for optionName in @configRerenderTriggers
      atom.config.onDidChange "weather.#{optionName}", @showWeather.bind(@)

    for optionName in @configRefreshTriggers
      atom.config.onDidChange "weather.#{optionName}", @refresh.bind(@)

  isVisible: ->
    @classList.contains('hidden')

  show: ->
    @classList.add('hidden')

  hide: ->
    @classList.remove('hidden')

  refresh: ->
    @data.refresh()

  showLoading: ->
    @content.innerText = "Getting weather for: #{@data.zipcode()}"

  showError: ->
    @content.innerText = "Cannot load weather: #{@data.errorText}"

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
    "#{config.prefix || ''}#{data}#{config.unit?[@data.units()] || ''}#{config.suffix || ''}"

  showWeather: ->
    return @showError() if @data.error

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
