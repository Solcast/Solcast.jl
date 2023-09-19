module Tmy

include("api.jl")
include("config.jl")

"""
    radiation_and_weather(latitude::Float64, longitude::Float64; kwargs...)
Get the irradiance and weather for a Typical Meteorological Year (TMY) at a requested location,
derived from satellite (clouds and irradiance over non-polar continental areas) and
numerical weather models (other data). The TMY is calculated with data from 2007 to 2023.

See https://docs.solcast.com.au/ for full list of parameters.
"""
function radiation_and_weather(latitude::Float64, longitude::Float64; kwargs...)

    client = Client(base_url, tmy_radiation_and_weather, user_agent)

    params = Dict("latitude" => latitude, "longitude" => longitude, "format" => "json")
    params = merge(params, kwargs)
    resp = get_response(client, params)

    return resp
end

"""
    rooftop_pv_power(latitude::Float64, longitude::Float64; kwargs...)
Get the basic rooftop PV power estimated actuals for a Typical Meteorological Year (TMY) at a requested location,
derived from satellite (clouds and irradiance over non-polar continental areas) and
numerical weather models (other data). The TMY is calculated with data from 2007 to 2023.

See https://docs.solcast.com.au/ for full list of parameters.
"""
function rooftop_pv_power(latitude::Float64, longitude::Float64; kwargs...)
    client = Client(base_url, tmy_rooftop_pv_power, user_agent)

    params = Dict("latitude" => latitude, "longitude" => longitude, "format" => "json")
    params = merge(params, kwargs)
    resp = get_response(client, params)

    return resp
end

export radiation_and_weather, rooftop_pv_power
end