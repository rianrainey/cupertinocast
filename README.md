# Cupertino Cast

This is a weather forecast app made for Apple Inc. It uses the WeatherApi.com API to fetch the weather data.

## Prerequisites

- Ruby
- Make sure you have the `master.key` that I emailed the recruiter so you can access the WeatherApi key.

## Setup

```
git clone https://github.com/rianrainey/cupertinocast.git
cd cupertinocast
bundle install
./bin/setup
./bin/dev
```

## Troubleshooting

If you can't access the weather_api key, you can create your own key on the [WeatherApi website](https://weatherapi.com/) and update `config/credentials/development.yml.enc` with the new key.
