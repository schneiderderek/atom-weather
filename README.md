# Weather

Displays the temperature and other weather related information in the status bar of Atom.

![Screenshot of dark theme imperial units](http://i.imgur.com/0f0l2gL.png)
![Screenshot of light theme imperial units](http://i.imgur.com/JCRQnV0.png)
![Screenshot of dark theme metric units](http://i.imgur.com/yAd6Ngh.png)

More features coming soon, feel free to put in requests or contribute!

## Api Key

Registration for a free api key at [openweathermap.org](http://openweathermap.org/appid) is required. Click the "Sign Up" button and then copy your unique api key into your atom-weather configuration.

If you are getting the error message "cannot load weather", check that the api key entered in configuration matches the one you were provided by openweathermap.org.


## Configuration

Configuration for weather can be found by going to: settings > packages > weather and click on settings.

The following configuration options are available, shown in the order they appear (alphabetically):

| Name | Description | Default |
| ------------- | ------------- | ----------- |
| Api Key | Obtain from http://openweathermap.org/appid. | |
| Latitude | Latitude (ignored if zipcode location method choosen) | 0 |
| Location Method | Whether to use zipcode or lat/long | zipcode |
| Longitude | Longitude (ignored if zipcode location method choosen) | 0 |
| Show High | High temp for the day | on |
| Show Humidity | Current humidity | on |
| Show Icon | icon associated with current weather | on |
| Show Low | Low temp for the day | on |
| Show Pressure | Current atmospheric pressure | on |
| Show Sunrise | Sunrise time | on |
| Show Sunset | Sunset time | on |
| Show Temp | Current temp | on |
| Show Wind Direction | Current wind direction | on |
| Show Wind Speed | Current wind speed | on |
| Units | Unit measurement | imperial |
| Update Interval | Number of minutes between updates | 15 min. |
| Zipcode | Location zipcode (ignored if lat/long location method choosen) | 43201 |

## Menu Options
To access the menu options click on the `Packages` option in the menubar, then `Weather`. There are currently two different options available in the package menu.

### Toggle
This activates and deactives the weather package.

### Refresh
This manually updates the weather.

## Weather API

This package uses http://openweathermap.org/
