# Welcome to Solcast

A simple Julia SDK that wraps [Solcast's API](https://docs.solcast.com.au/).

## Install

From the directory, open Julia REPL and go to `Package Management Mode` by pressing `]` and run the following:

```bash
dev .
```

OR

To install from Julia registry, open Julia REPL, go to `Package Management Mode` and run the following:

```bash
add Solcast
```

## Usage

!!! warning

    To access Solcast data you will need an API key. If you have the API key already,
    you can use it with this library either as an environment variable called `SOLCAST_API_KEY`,
    or you can pass it as an argument `api_key` when you call one of the library's methods.

Fetching live radiation and weather data:

```julia
using Solcast: Live

res = Live.radiation_and_weather(
        -33.856784,
        151.215297,
        ["air_temp", "dni", "ghi"]
    )
```

As a `DataFrame.jl` dataframe

```julia
df = Live.to_dataframe(res)
```

Available modules are

| Module         | API Docs                       |
| -------------- | ------------------------------ |
| `Live`       | [Solcast.Live](live.md)           |
| `Historical` | [Solcast.Historical](historic.md) |
| `Forecast`   | [Solcast.Forecast](forecast.md)   |
| `Tmy`        | [Solcast.Tmy](tmy.md)             |

## Docs

From the directory, run the following:

```bash
julia --project=. docs/make.jl
```

Navigate to `docs/build` and run `python -m http.server` to start a local server on port 8000.

In a browser navigate to `localhost:8000` to see the documentation.

## Contributing & License

Any type of suggestion and code contribution is welcome as PRs and/or Issues.
This repository is licensed under MIT (see LICENSE).
