require "rails_helper"

describe Categorize do
  it "percentile_50 method returns correct percentile for a given dataset/array" do
    Restaurant.create(name: "r1", street_address: "27 East Parade", post_code: "LS1 5BN", number_of_chairs: 22)
    Restaurant.create(name: "r2", street_address: "27 West Parade", post_code: "LS1 5BN", number_of_chairs: 23)
    Restaurant.create(name: "r3", street_address: "27 North Parade", post_code: "LS1 5BN", number_of_chairs: 27)
    Restaurant.create(name: "r4", street_address: "27 North Parade", post_code: "LS1 5BN", number_of_chairs: 29)
    Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS1 5BN", number_of_chairs: 32)

    Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 32)
    Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 35)
    Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 37)
    Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 45)
    Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 57)
    Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 83)

    categorize = Categorize.new

    ls1_index = 2.5
    nearest_whole_num = 3
    expected_value_ls1 = 27

    expected_value_ls2 = 41

    expect(categorize.percentile_50("LS1")).to eq(expected_value_ls1)
    expect(categorize.percentile_50("LS2")).to eq(expected_value_ls2)
  end

  it "sets the category of ls1 restaurants" do
    ls1_1 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS1 5BN", number_of_chairs: 5)
    ls1_2 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS1 5BN", number_of_chairs: 57)
    ls1_3 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS1 5BN", number_of_chairs: 123)

    ls2_1 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 5)
    ls2_2 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 10)
    ls2_3 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 15)
    ls2_4 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS2 5BN", number_of_chairs: 20)

    other_1 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS7 5BN", number_of_chairs: 15)
    other_2 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS5 5BN", number_of_chairs: 20)

    ls1_restaurants = Restaurant.find_post_codes("LS1")
    ls2_restaurants = Restaurant.find_post_codes("LS2")
    other_restaurants = Restaurant.find_post_codes()

    categorize = Categorize.new
    categorize.set_ls1_categories(ls1_restaurants)

    reload_ls1_1 = ls1_1.reload
    reload_ls1_2 = ls1_2.reload
    reload_ls1_3 = ls1_3.reload

    expect(reload_ls1_1.category).to eq("ls1 small")
    expect(reload_ls1_2.category).to eq("ls1 medium")
    expect(reload_ls1_3.category).to eq("ls1 large")

    categorize.set_ls2_categories(ls2_restaurants, 12.5)

    reload_ls2_1 = ls2_1.reload
    reload_ls2_2 = ls2_2.reload
    reload_ls2_3 = ls2_3.reload
    reload_ls2_4 = ls2_4.reload

    expect(reload_ls2_1.category).to eq("ls2 small")
    expect(reload_ls2_2.category).to eq("ls2 small")
    expect(reload_ls2_3.category).to eq("ls2 large")
    expect(reload_ls2_4.category).to eq("ls2 large")

    categorize.set_other_categories(other_restaurants)

    other_1_reload = other_1.reload
    other_2_reload = other_2.reload

    expect(other_1_reload.category).to eq("other")
    expect(other_2_reload.category).to eq("other")
  end


end
