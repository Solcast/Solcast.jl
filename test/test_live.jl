using DataFrames
using Solcast: Live, to_dict, to_dataframe, load_test_locations_coordinates
using Test

@testset "live: test radiation and weather" begin
    lats, longs, resources_ids = load_test_locations_coordinates()
    res = Live.radiation_and_weather(lats[1], longs[1], ["dni", "ghi"])

    @test res.status_code == 200
    @test res.success == true
    @test Live.to_dict(res)["estimated_actuals"][1]["period"] == "PT30M"
    @test names(Live.to_dataframe(res)) == ["period_end", "dni", "ghi"]
end

@testset "live: test rooftop pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Live.rooftop_pv_power(lats[1], longs[1]; capacity=3)

    @test res.status_code == 200
    @test res.success == true
    @test Live.to_dict(res)["estimated_actuals"][1]["period"] == "PT30M"
    @test names(Live.to_dataframe(res)) == ["period_end", "pv_power_rooftop"]
end

@testset "live: fail rooftop pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Live.rooftop_pv_power(lats[1], longs[1])

    @test res.status_code == 400
    @test res.success == false
    @test res.exception == "'Capacity' must be greater than '0'."
end

@testset "live: test advanced pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Live.advanced_pv_power(resources_ids[1])

    @test res.status_code == 200
    @test res.success == true
    @test Live.to_dict(res)["estimated_actuals"][1]["period"] == "PT30M"
    @test names(Live.to_dataframe(res)) == ["period_end", "pv_power_advanced"]

end

