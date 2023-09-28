using Solcast: Historic, check_params, version, ValueError, Client, Response, base_url, historic_radiation_and_weather, user_agent, to_dict, to_dataframe, get_response, load_test_locations_coordinates
using Test

@test version == "0.1.2"

# Fails because the API key is short in size
@testset "fail when API key is short" begin
    params = Dict("api_key" => "", "latitude" => -33.856784, "longitude" => 151.215297)
    @test_throws ValueError check_params(params)
end

# Pass key in params
@test check_params(Dict("api_key" => "test-key"))[2] == "test-key"

@testset "test client and its methods" begin
    client = Client(base_url, historic_radiation_and_weather, user_agent)
    params = Dict("latitude" => -33.856784, "longitude" => 151.215297, "start" => "2022-10-25T14:45:00.000Z", "format" => "json", "output_parameters" => ["air_temp"], "duration" => "P1D")

    checked_params, key = check_params(params)

    @test checked_params["latitude"] == -33.856784
    @test checked_params["longitude"] == 151.215297

    res = get_response(client, params)

    @test res.status_code == 200
    @test res.success == true
    @test length(to_dict(res)) == 1

end

@testset "make a request with api key sent as parameter" begin
    lats, longs, resources_ids = load_test_locations_coordinates()
    res = Historic.radiation_and_weather(lats[1], longs[1], "2022-10-25T14:45:00.000Z"; output_parameters=["air_temp"], duration="P1D", api_key=ENV["SOLCAST_API_KEY"])

    @test res.status_code == 200
    @test res.success == true
    @test length(Historic.to_dict(res)) == 1
    @test size(Historic.to_dataframe(res))[2] == 2

end

@testset "validates response" begin
    raw_data = Vector{UInt8}([0x74, 0x65, 0x73, 0x74, 0x20, 0x64, 0x61, 0x74, 0x61])
    res = Response(200, "https://api.solcast.com.au/data", raw_data, true, nothing)

    @test res.status_code == 200
    @test res.success == true
end