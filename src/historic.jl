module Historic

include("api.jl")
include("config.jl")

"""
    radiation_and_weather(latitude::Float64, longitude::Float64, start::String; kwargs...)
Get historical irradiance and weather estimated actuals for up to 31 days of data
at a time for a requested location, derived from satellite (clouds and irradiance
over non-polar continental areas) and numerical weather models (other data).
Data is available from 2007-01-01T00:00Z up to real time estimated actuals.

See https://docs.solcast.com.au/ for full list of parameters.
"""
function radiation_and_weather(latitude::Float64, longitude::Float64, start::String; kwargs...)
    client = Client(base_url, historic_radiation_and_weather, user_agent)

    params = Dict("latitude" => latitude, "longitude" => longitude, "start" => start, "format" => "json")
    params = merge(params, kwargs)
    resp = get_response(client, params)

    return resp
end

"""
    rooftop_pv_power(latitude::Float64, longitude::Float64, start::String; kwargs...)
Get historical basic rooftop PV power estimated actuals for the requested location,
derived from satellite (clouds and irradiance over non-polar continental areas)
and numerical weather models (other data).

See https://docs.solcast.com.au/ for full list of parameters.
"""
function rooftop_pv_power(latitude::Float64, longitude::Float64, start::String; kwargs...)
    client = Client(base_url, historic_rooftop_pv_power, user_agent)

    params = Dict("latitude" => latitude, "longitude" => longitude, "start" => start, "format" => "json")
    params = merge(params, kwargs)
    resp = get_response(client, params)

    return resp
end

export radiation_and_weather, rooftop_pv_power
end