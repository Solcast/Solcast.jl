using DataFrames
using Solcast: Tmy, to_dict, to_dataframe, load_test_locations_coordinates
using Test

@testset "tmy: test radiation and weather" begin
    lats, longs, resources_ids = load_test_locations_coordinates()
    res = Tmy.radiation_and_weather(lats[1], longs[1]; output_parameters=["dni", "ghi"])

    @test res.status_code == 200
    @test res.success == true
    @test Tmy.to_dict(res)["estimated_actuals"][1]["period"] == "PT60M"
    @test names(Tmy.to_dataframe(res)) == ["period_end", "dni", "ghi"]
end

@testset "tmy: test rooftop pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Tmy.rooftop_pv_power(lats[1], longs[1]; capacity=3)

    @test res.status_code == 200
    @test res.success == true
    @test Tmy.to_dict(res)["estimated_actuals"][1]["period"] == "PT1H"
    @test names(Tmy.to_dataframe(res)) == ["period_end", "pv_power_rooftop"]
end

@testset "tmy: fail rooftop pv power" begin
    lats, longs, resources_ids = load_test_locations_coordinates()

    res = Tmy.rooftop_pv_power(lats[1], longs[1]; array_type="wrong")

    @test res.status_code == 400
    @test res.success == false
    @test res.exception == "The specified condition was not met for 'Array Type'."
end
