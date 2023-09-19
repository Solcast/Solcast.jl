UNMETERED_LOCATIONS = Dict(
    "Sydney Opera House" => Dict(
        "latitude" => -33.856784,
        "longitude" => 151.215297,
        "resource_id" => "5f86-4c8f-2cb3-0215"
    ),
    "Grand Canyon" => Dict(
        "latitude" => 36.099763,
        "longitude" => -112.112485,
        "resource_id" => "375f-eb3e-71c0-ef5e",
    ),
    "Stonehenge" => Dict(
        "latitude" => 51.178882,
        "longitude" => -1.826215,
        "resource_id" => "1a57-6b1f-ec18-c5c8",
    ),
    "The Colosseum" => Dict(
        "latitude" => 41.89021,
        "longitude" => 12.492231,
        "resource_id" => "5f86-4c8f-2cb3-0215",
    ),
    "Giza Pyramid Complex" => Dict(
        "latitude" => 29.977296,
        "longitude" => 31.132496,
        "resource_id" => "8d10-f530-af85-5cbb",
    ),
    "Taj Mahal" => Dict(
        "latitude" => 27.175145,
        "longitude" => 78.042142,
        "resource_id" => "b926-8fd2-ad3f-e4f5",
    ),
)

function load_test_locations_coordinates()
    """
    returns latitude, longitude and resource_id for the unmetered locations
    """

    latitudes::Array{Float64} = []
    longitudes::Array{Float64} = []
    resource_ids::Array{String} = []

    for location in keys(UNMETERED_LOCATIONS)
        push!(latitudes, UNMETERED_LOCATIONS[location]["latitude"])
        push!(longitudes, UNMETERED_LOCATIONS[location]["longitude"])
        push!(resource_ids, UNMETERED_LOCATIONS[location]["resource_id"])
    end

    return latitudes, longitudes, resource_ids
end

function load_test_location_names()
    """
    returns the unmetered locations
    """

    return keys(UNMETERED_LOCATIONS)
end