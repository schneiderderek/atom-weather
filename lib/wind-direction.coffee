module.exports =
class WindDirection
  cardinal: null
  degrees: null
  directionMappings:
    N:
      min: 0.00
      max: 11.25
    NNE:
      min: 11.25
      max: 33.75
    NE:
      min: 33.75
      max: 56.25
    ENE:
      min: 56.25
      max: 78.75
    E:
      min: 78.75
      max: 101.25
    ESE:
      min: 101.25
      max: 123.75
    SE:
      min: 123.75
      max: 146.25
    SSE:
      min: 146.25
      max: 168.75
    S:
      min: 168.75
      max: 191.25
    SSW:
      min: 191.25
      max: 213.75
    SW:
      min: 213.75
      max: 236.25
    WSW:
      min: 236.25
      max: 258.75
    W:
      min: 258.75
      max: 281.25
    WNW:
      min: 281.25
      max: 303.75
    NW:
      min: 303.75
      max: 326.25
    NNW:
      min: 326.25
      max: 348.75
    N:
      min: 348.75
      max: 360.00
  constructor: (degrees) ->
    for direction, bounds of @directionMappings
      if degrees >= bounds.min && degrees < bounds.max
        @cardinal = direction
        break
