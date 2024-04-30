# Cupertino Cast

This is a weather forecast app made for Apple Inc. It uses the WeatherApi.com API to fetch the weather data.

<img width="400" alt="Screenshot 2024-04-30 at 3 57 53 PM" src="https://github.com/rianrainey/cupertinocast/assets/523354/ed40da09-b1ad-486a-8a7f-55bc66d649c6">



## Prerequisites

- Ruby
- Make sure you have the `config/development.key` that I emailed the recruiter so you can access the WeatherApi credentials.

## Setup

```
git clone https://github.com/rianrainey/cupertinocast.git
cd cupertinocast
bundle install
./bin/setup
echo 'development.key from recruiter here 123' > config/credentials/development.key
./bin/dev
```

## Troubleshooting

If you can't access the weather_api key, you can create your own key on the [WeatherApi website](https://weatherapi.com/) and update `config/credentials/development.yml.enc` with the new key. Or email me and I can get it to you :)
