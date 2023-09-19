using DataFrames
using Solcast: Forecast, to_dict, to_dataframe, load_test_locations_coordinates
using Test

@testset "forecast: test radiation and weather" begin
    lats, longs, resources_ids = load_test_locations_coordinates()
    res = Forecast.radiation_and_weather(lats[4], longs[4], ["albedo"]; hours=3)

    @test res.status_code == 200
    @test res.success == true
    @test Forecast.to_dict(res)["forecasts"][1]["period"] == "PT30M"
    @test names(Forecast.to_dataframe(res)) == ["period_end", "albedo"]
end

@testset "forecast: test rooftop pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Forecast.rooftop_pv_power(lats[3], longs[3], ["pv_power_rooftop10"]; capacity=1, hours=3)

    @test res.status_code == 200
    @test res.success == true
    @test Forecast.to_dict(res)["forecasts"][1]["period"] == "PT30M"
    @test names(Forecast.to_dataframe(res)) == ["period_end", "pv_power_rooftop"]
end

@testset "forecast: test advanced pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Forecast.advanced_pv_power(resources_ids[1]; capacity=1, hours=3)

    @test res.status_code == 200
    @test res.success == true
    @test Forecast.to_dict(res)["forecasts"][1]["period"] == "PT30M"
    @test names(Forecast.to_dataframe(res)) == ["period_end", "pv_power_advanced"]

end

