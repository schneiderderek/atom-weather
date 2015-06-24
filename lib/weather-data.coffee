module.exports =
class WeatherData
  apiCallTypes:
    current:
      urlFunctionName: 'currentWeatherUrl'
      handlerFunctionName: 'handleCurrentResponse'
    forecast:
      urlFunctionName: 'forecastWeatherUrl'
      handlerFunctionName: 'handleForecastResponse'
  location: null
  error: false
  constructor: (viewCallback) ->
    @viewCallback = viewCallback

    @refresh()
    setInterval(@refresh.bind(@), @updateInterval())

  refresh: ->
    console.info('Fetching weather')
    @weatherApiCall @apiCallTypes.current

  zipcode: ->
    atom.config.get('weather.zipcode')

  updateInterval: ->
    atom.config.get('weather.updateInterval') * 60 * 1000

  apiZipcodeFormat: ->
    "#{@zipcode()},us"

  currentWeatherUrl: ->
    "http://api.openweathermap.org/data/2.5/weather?zip=#{@apiZipcodeFormat()}&units=imperial"

  forecastWeatherUrl: ->
    lat = @location.lat
    lon = @location.lon
    return null unless lat? && lon?
    "http://api.openweathermap.org/data/2.5/forecast/daily?lat=#{lat}&lon=#{lon}&units=imperial&cnt=1"

  parseUnixTimestamp: (timestamp) ->
    new Date(timestamp * 1000)

  # Format the time without seconds
  formatTime: (time) ->
    time.toLocaleTimeString(navigator.language, {hour: '2-digit', minute:'2-digit'});

  handleCurrentResponse: (data) ->
    @location = data.coord
    @temp = Math.round(data.main.temp)
    @humidity = Math.round(data.main.humidity)
    @iconCode = data.weather[0].icon
    @sunrise = @formatTime @parseUnixTimestamp(data.sys.sunrise)
    @sunset = @formatTime @parseUnixTimestamp(data.sys.sunset)
    @pressure = Math.round(data.main.pressure)

    @weatherApiCall @apiCallTypes.forecast

    @viewCallback()

  handleForecastResponse: (data) ->
    forcastTemps = data.list[0].temp
    @high = Math.round(forcastTemps.max)
    @low = Math.round(forcastTemps.min)

    @viewCallback()

  handleApiError: (message) ->
    @error = true
    @errorText = message

    console.error 'Error fetching data from API'
    console.error message

    @viewCallback()

  parseJSON: (string) ->
    result = null

    try
      o = JSON.parse string
      result = o if o && typeof o == 'object'
    catch error
      console.warn 'Error parsing JSON from API'
      result = { message: 'Error parsing JSON from API' }

    result

  weatherApiCall: (options) ->
    console.log "Fetching weather using #{options.urlFunctionName}"
    url = @[options.urlFunctionName]()
    handler = @[options.handlerFunctionName]
    return false unless url? && handler?

    request = new XMLHttpRequest()
    request.open 'GET', url
    request.send()
    model = @

    request.onreadystatechange = ->
      if request.readyState == 4 && request.status == 200
        response = model.parseJSON(request.responseText)

        # The openweathermap API seems to always return a 200 HTTP status.
        # Check the response to make sure it was actually successful.
        if response && (response.cod == 200 || response.cod == '200') # Not a typo
          handler.bind(model)(response)
          model.error = false
        else
          model.handleApiError.bind(model)(response.message)
      else if request.readyState == 4
        model.handleApiError.bind(model)('API Error')
