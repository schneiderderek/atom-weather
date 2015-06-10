class WeatherView extends HTMLElement
  initialize: ->
    @classList.add('weather', 'inline-block')

    @content = document.createElement('div')
    @content.classList.add('weather-content')

    @appendChild(@content)

    @showLoading()
    @fetchWeather()

  isVisible: ->
    @classList.contains('hidden')

  show: ->
    @classList.add('hidden')

  hide: ->
    @classList.remove('hidden')

  showLoading: ->
    @content.innerText = 'Getting weather for: ' + @zipcode()

  zipcode: ->
    atom.config.get('weather.zipcode')

  weatherUrl: ->
    'http://api.openweathermap.org/data/2.5/weather?zip=' + @zipcode() + ',us&units=imperial'

  showWeather: (weather) ->
    @content.innerText = weather.main.temp + 'F'

  fetchWeather: ->
    console.info('Fetching weather')
    request = new XMLHttpRequest()
    request.open 'GET', @weatherUrl()
    request.send()
    view = @

    request.onreadystatechange = ->
      if (request.readyState == 4 && request.status == 200)
        view.showWeather JSON.parse(request.responseText)


module.exports = document.registerElement('status-bar-weather',
                                          prototype: WeatherView.prototype,
                                          extends: 'div')
