using Solcast: Historic, to_dict, to_dataframe, load_test_locations_coordinates
using Test

@testset "historic: test radiation and weather" begin
    lats, longs, resources_ids = load_test_locations_coordinates()
    res = Historic.radiation_and_weather(lats[1], longs[1], "2022-10-25T14:45:00.000Z"; output_parameters=["air_temp"], duration="P1D")

    @test res.status_code == 200
    @test res.success == true
    @test length(Historic.to_dict(res)) == 1
    @test size(Historic.to_dataframe(res))[2] == 2
end

@testset "historic: test rooftop pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Historic.rooftop_pv_power(lats[1], longs[1], "2022-10-25T14:45:00.000Z"; capacity=10, duration="P3D")

    @test res.status_code == 200
    @test res.success == true
    @test length(Historic.to_dict(res)["estimated_actuals"]) == 3 * 48 + 1
    @test size(Historic.to_dataframe(res))[2] == 2
end

@testset "historic: fail duration and end date" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Historic.radiation_and_weather(lats[1], longs[1], "2022-10-25T14:45:00.000Z"; duration="P3D", end_date="2022-10-25T18:45:00.00Z")

    @test res.status_code == 400
    @test res.success == false
    @test res.exception == "Must specify exactly one of duration or end_date"
end