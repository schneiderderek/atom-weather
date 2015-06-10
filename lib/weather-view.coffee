class WeatherView extends HTMLElement
  initialize: ->
    @classList.add('weather', 'inline-block')

    @content = document.createElement('div')
    @content.classList.add('weather-content')

    @appendChild(@content)

    @showLoading()

    @fetchWeather()
    setInterval(@fetchWeather.bind(@), @updateInterval())

    atom.config.onDidChange 'weather.zipcode', @fetchWeather.bind(@)
    atom.config.onDidChange 'weather.showIcon', @fetchWeather.bind(@)

  isVisible: ->
    @classList.contains('hidden')

  show: ->
    @classList.add('hidden')

  hide: ->
    @classList.remove('hidden')

  updateInterval: ->
    atom.config.get('weather.updateInterval') * 60 * 1000

  showLoading: ->
    @content.innerText = 'Getting weather for: ' + @zipcode()

  showError: (errorText) ->
    @content.innerText = 'Cannot load weather: ' + errorText

  zipcode: ->
    atom.config.get('weather.zipcode')

  iconUrl: (iconName) ->
    'http://openweathermap.org/img/w/' + iconName + '.png'

  showIcon: (iconName) ->
    return unless atom.config.get 'weather.showIcon'

    img = document.createElement('img')
    img.setAttribute('src', @iconUrl(iconName))
    @content.appendChild(img)

  weatherUrl: ->
    'http://api.openweathermap.org/data/2.5/weather?zip=' + @zipcode() + ',us&units=imperial'

  showWeather: (weather) ->
    @content.innerText = Math.round(weather.main.temp) + 'F'
    @showIcon(weather.weather[0].icon)

  fetchWeather: ->
    console.info('Fetching weather')
    request = new XMLHttpRequest()
    request.open 'GET', @weatherUrl()
    request.send()
    view = @

    request.onreadystatechange = ->
      if request.readyState == 4 && request.status == 200
        response = JSON.parse(request.responseText)

        # The openweathermap API seems to always return a 200 HTTP status.
        # Check the response to make sure it was actually successful.
        if response.cod == 200
          view.showWeather response
        else
          view.showError response.message


module.exports = document.registerElement('status-bar-weather',
                                          prototype: WeatherView.prototype,
                                          extends: 'div')
