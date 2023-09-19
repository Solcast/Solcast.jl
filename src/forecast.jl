module Forecast

include("api.jl")
include("config.jl")

"""
    radiation_and_weather(latitude::Float64, longitude::Float64, output_parameters::Array{String,1}; kwargs...)
Get irradiance and weather forecasts from the present time up to 14 days ahead
for the requested location, derived from satellite (clouds and irradiance
over non-polar continental areas, nowcasted for approx. four hours ahead)
and numerical weather models (other data and longer horizons).
"""
function radiation_and_weather(latitude::Float64, longitude::Float64, output_parameters::Array{String,1}; kwargs...)
    client = Client(base_url, forecast_radiation_and_weather, user_agent)

    params = Dict("latitude" => latitude, "longitude" => longitude, "output_parameters" => output_parameters, "format" => "json")
    params = merge(params, kwargs)
    resp = get_response(client, params)

    return resp
end

"""
    rooftop_pv_power(latitude::Float64, longitude::Float64, output_parameters::Array{String,1}; kwargs...)
Get basic rooftop PV power forecasts from the present time up to 14 days ahead
for the requested location, derived from satellite (clouds and irradiance over
non-polar continental areas, nowcasted for approx. four hours ahead) and numerical
weather models (other data and longer horizons).

See https://docs.solcast.com.au/ for full list of parameters.
"""
function rooftop_pv_power(latitude::Float64, longitude::Float64, output_parameters::Array{String,1}; kwargs...)
    client = Client(base_url, forecast_rooftop_pv_power, user_agent)

    params = Dict("latitude" => latitude, "longitude" => longitude, output_parameters => output_parameters, "format" => "json")
    params = merge(params, kwargs)
    resp = get_response(client, params)

    return resp
end

"""
    advanced_pv_power(resource_id::String; kwargs...)
Get high spec PV power forecasts from the present time up to 14 days ahead
for the requested site, derived from satellite (clouds and irradiance over
non-polar continental areas, nowcasted for approx. four hours ahead) and
numerical weather models (other data and longer horizons).

See https://docs.solcast.com.au/ for full list of parameters.
"""
function advanced_pv_power(resource_id::String; kwargs...)
    client = Client(base_url, forecast_advanced_pv_power, user_agent)

    params = Dict("resource_id" => resource_id, "format" => "json")
    params = merge(params, kwargs)
    resp = get_response(client, params)

    return resp
end

export radiation_and_weather, rooftop_pv_power, advanced_pv_power
end