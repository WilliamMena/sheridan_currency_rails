# About

This application converts a specified amount of money through multiple currency rates.

The basics of the application are that you insert an amount, the country where you want to convert the money from and the new country where you would want to convert the money to. After that there is an output that will show the specified amount's conversion.

When the conversion rate is first called through the API, it will be cached inside of the application and stored for 1 minute. If within that minute the API is called again for that exact conversion, the cache data will be retrieved instead of calling the API again. If a new conversion rate is requested for a different combination of countries, the API will be called again.



# Setup

After downloading the repo, running ```rails s``` in your terminal will start the application.
No need to create a DB or run postgres in the background.
