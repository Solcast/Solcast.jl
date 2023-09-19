include("error.jl")
include("config.jl")

using DataFrames
using Dates
using HTTP
using JSON

"""
    struct Response

Represents the response received from the Solcast API.

# Fields
- `status_code::Int64`: The HTTP status code.
- `url::String`: The URL of the response.
- `data::Union{Vector{UInt8}, Nothing}`: The response data as bytes or `Nothing` if not available.
- `success::Bool`: `true` if the request was successful, `false` otherwise.
- `exception::Union{String, Nothing}`: An exception message if the request failed, `Nothing` otherwise.

"""
struct Response
    status_code::Int64
    url::String
    data::Union{Vector{UInt8}, Nothing}
    success::Bool
    exception::Union{String, Nothing}
end

"""
    to_dict(response::Response)

Converts the response data to a dictionary (JSON) if the response is successful.

# Arguments
- `response::Response`: The HTTP response object.

# Returns
- `parsed::Dict{String, Any}`: The parsed JSON data.

# Throws
- `invalid_response_error`: If the response is not successful.

"""
function to_dict(response::Response)

    if response.success
        data = deepcopy(response.data)
        parsed = JSON.parse(String(data))
        return parsed
    else
        throw(invalid_response_error)
    end
end

"""
    to_dataframe(response::Response)

Converts the response data to a DataFrame if the response is successful.

# Arguments
- `response::Response`: The HTTP response object.

# Returns
- `dfs::DataFrame`: The DataFrame containing the response data.

# Throws
- `invalid_response_error`: If the response is not successful.

"""
function to_dataframe(response::Response)
    if !response.success
        throw(invalid_response_error)
    end

    data_dict = to_dict(response)
    dfs = [DataFrame(data_dict[k]) for k in keys(data_dict)]

    # Concatenate the data frames into one
    dfs = vcat(dfs...)

    dfs."period_end" = DateTime.(dfs."period_end", "yyyy-mm-ddTHH:MM:SS.ssssssZ")

    # Drop unwanted columns
    select!(dfs, Not(:period))

    return dfs
end


"""
    struct Client

Represents a client for making API requests.

# Fields
- `base_url::String`: The base URL for the API.
- `endpoint::String`: The API endpoint.
- `user_agent::String`: The user agent string.

"""
struct Client
    base_url::String
    endpoint::String
    user_agent::String
end

"""
    make_url(client::Client)

Generates the full URL based on the client's base URL and endpoint.

# Arguments
- `client::Client`: The API client.

# Returns
- `url::String`: The full URL.

"""
make_url(client::Client) = client.base_url * client.endpoint

# Generates the user agent
user_agent = "solcast-api-julia-sdk/" * version

"""
    check_params(params::Dict)

Validates and prepares the parameters for an API request.

# Arguments
- `params::Dict`: A dictionary of request parameters.

# Returns
- `params::Dict`: The validated and modified request parameters.
- `key::String`: The API key extracted from the parameters.

# Throws
- `ValueError`: If validation fails or if the API key is missing or too short.

"""
function check_params(params::Dict)
    # Validates that the params dictionary has an api_key
    if !haskey(params, "api_key")
        if haskey(ENV, "SOLCAST_API_KEY")
            params["api_key"] = ENV["SOLCAST_API_KEY"]
        else
            throw(ValueError(
                """
                no API key provided. Either set it as an environment \
                variable SOLCAST_API_KEY, or provide `api_key` \
                as an argument. Visit https://solcast.com to get an API key.
                """
            ))
        end
    end

    #Validates the length of the API key
    if length(params["api_key"]) <= 1
        throw(ValueError("API key is too short."))
    end

    # Joins the output parameters into a comma-separated string if the "output_parameters" key is present
    if haskey(params, "output_parameters") && isa(params["output_parameters"], Array)
        params["output_parameters"] = join(params["output_parameters"], ",")
    end

    # Rounds the latitude and longitude to 6 decimal places if they are present
    if haskey(params, "latitude")
        params["latitude"] = round(params["latitude"], digits=6)
    end

    if haskey(params, "longitude")
        params["longitude"] = round(params["longitude"], digits=6)
    end

    # Validates that the format is json
    if haskey(params, "format")
        @assert params["format"] == "json" "only json response format is currently supported."
    end

    key = params["api_key"]
    delete!(params, "api_key")

    return params, key
end

"""
    get_response(client::Client, params::Dict)

Sends an HTTP GET request and returns a Response object.

# Arguments
- `client::Client`: The API client.
- `params::Dict`: A dictionary of request parameters.

# Returns
- `response_object::Response`: The HTTP response as a Response object.

"""
function get_response(client::Client, params::Dict)
    params, key = check_params(params)
    url = make_url(client)

    headers = Dict("Authorization" => "Bearer $key", "User-Agent" => client.user_agent)

    response_object = nothing
    try
        response = HTTP.get(url, headers, query=params)
        if HTTP.status(response) == 200
            response_object = Response(
                response.status,
                string(response.request.url),
                response.body,
                true,
                nothing
            )
        end

    catch e
        response = e.response
        response_object = Response(
            response.status,
            url,
            response.body,
            false,
            JSON.parse(String(response.body))["response_status"]["message"]
        )
    end

    return response_object
end
