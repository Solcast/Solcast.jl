# Live
Get irradiance weather and power estimated actuals for near real-time and past 7 days for the requested location,
derived from satellite (clouds and irradiance over non-polar continental areas)
and numerical weather models (other data). More information in the [API Docs](https://docs.solcast.com.au/?#c1726d91-8a67-4803-89f4-02ecb5f03c05).

The module `Live` has 3 available methods:

| Endpoint                | API Docs                                                                                                |
|-------------------------|---------------------------------------------------------------------------------------------------------|
| `radiation_and_weather` | [details](https://docs.solcast.com.au/?#a12d0792-38eb-442b-a6d1-43571980becb) |
| `rooftop_pv_power`      | [details](https://docs.solcast.com.au/?#355068c3-8403-4e33-a5e9-1b79888968c4) |
| `advanced_pv_power`     | [details](https://docs.solcast.com.au/?#0c9d3ccf-e2a4-4583-86a3-f89c8d658fde) |

### Example

```julia
using Solcast: Live

res = Live.radiation_and_weather(
        -33.856784,
        151.215297,
        ["dni", "ghi"]
    )
```

As a `DataFrame.jl` dataframe

```julia
df = Live.to_dataframe(res)
```


| period_end                |   dni |   ghi |
|:--------------------------|------:|------:|
| 2023-08-18 04:00:00+00:00 |   817 |   575 |
| 2023-08-18 03:30:00+00:00 |   883 |   634 |
| 2023-08-18 03:00:00+00:00 |   412 |   532 |
| 2023-08-18 02:30:00+00:00 |   492 |   570 |
| 2023-08-18 02:00:00+00:00 |   197 |   473 |