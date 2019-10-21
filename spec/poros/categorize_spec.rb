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
  describe "concatenate names med large rake task method tests" do
    it "concatenates med and large restaurants category and name, and writes it to category" do
    small_1 = Restaurant.create(name: "r1", street_address: "27 North Parade", post_code: "LS7 5BN", number_of_chairs: 15, category: "ls1 small")
    small_2 = Restaurant.create(name: "r2", street_address: "27 North Parade", post_code: "LS5 5BN", number_of_chairs: 20, category: "ls1 small")

    med_1 = Restaurant.create(name: "r3", street_address: "27 North Parade", post_code: "LS7 5BN", number_of_chairs: 15, category: "ls1 medium")
    med_2 = Restaurant.create(name: "r4", street_address: "27 North Parade", post_code: "LS5 5BN", number_of_chairs: 20, category: "ls1 medium")

    large_1 = Restaurant.create(name: "r5", street_address: "27 North Parade", post_code: "LS7 5BN", number_of_chairs: 15, category: "ls1 large")
    large_2 = Restaurant.create(name: "r6", street_address: "27 North Parade", post_code: "LS5 5BN", number_of_chairs: 20, category: "ls1 large")

    categorize = Categorize.new
    med_and_large = Restaurant.return_med_and_large

    expect(med_and_large).to eq([med_1, med_2, large_1, large_2])

    categorize.concat_name_and_category(med_and_large)

    m1_reload = med_1.reload
    m2_reload = med_2.reload

    l1_reload = large_1.reload
    l2_reload = large_2.reload

    expect(l1_reload.name).to eq("ls1 large r5")
    expect(l2_reload.name).to eq("ls1 large r6")

    expect(m1_reload.name).to eq("ls1 medium r3")
    expect(m2_reload.name).to eq("ls1 medium r4")
    end
  end
end
