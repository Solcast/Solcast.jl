# Forecast

Get irradiance, weather and power forecasts from the present time up to 14 days ahead for
the requested location, derived from satellite (clouds and irradiance over non-polar continental areas,
nowcasted for approx. four hours ahead) and numerical weather models (other data and longer horizons).
More information in the [API docs](https://docs.solcast.com.au/#49090b36-66db-4d0f-89d5-87d19f00bec1).

The module `Forecast` has 3 available methods:

| Endpoint                  | API Docs                                                                               |
| ------------------------- | -------------------------------------------------------------------------------------- |
| `radiation_and_weather` | [details](https://docs.solcast.com.au/?#b78a2ee4-c8e5-4ae6-9fb3-c8bbefe91efc) |
| `rooftop_pv_power`      | [details](https://docs.solcast.com.au/?#25ff8ad7-e2a8-44be-9d2e-62e0f73cefd6) |
| `advanced_pv_power`     | [details](https://docs.solcast.com.au/?#0c9d3ccf-e2a4-4583-86a3-f89c8d658fde) |

### Example

```julia
using Solcast: Forecast

res = Forecast.radiation_and_weather(
        -33.856784,
        151.215297,
        ["air_temp"]
    )
```

As a `DataFrame.jl` dataframe

```julia
df = Forecast.to_dataframe(res)
```


| period_end                | air_temp |
| :------------------------ | -------: |
| 2023-08-18 04:00:00+00:00 |       16 |
| 2023-08-18 04:30:00+00:00 |       15 |
| 2023-08-18 05:00:00+00:00 |       15 |
| 2023-08-18 05:30:00+00:00 |       15 |
| 2023-08-18 06:00:00+00:00 |       15 |
