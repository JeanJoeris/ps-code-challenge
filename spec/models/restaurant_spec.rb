require 'rails_helper'

describe Restaurant, type: :model do
  describe "Validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :post_code}
    it {should validate_presence_of :number_of_chairs}
  end

#   post_code: The Post Code
#   total_places: The number of places in that Post Code
#   total_chairs: The total number of chairs in that Post Code
# => chairs_pct: Out of all the chairs at all the Post Codes, what percentage does this Post Code represent (should sum to 100% in the whole view)
# place_with_max_chairs: The name of the place with the most chairs in that Post Code -max_chairs: The number of chairs at the place_with_max_chairs


  describe "Post code data view returning the following columns" do
    before :each do
      @r1 = Restaurant.create(name: "All Bar One", street_address: "27 East Parade", post_code: "LS1 5BN", number_of_chairs: 20)
      @r2 = Restaurant.create(name: "Bagel Nash", street_address: "18 Swan Street", post_code: "LS1 5BN", number_of_chairs: 18)
      @r3 = Restaurant.create(name: "Bella Italia", street_address: "145 Briggate", post_code: "LS1 5BN", number_of_chairs: 32)

      @r4 = Restaurant.create(name: "Cattle Grid", street_address: "Waterloo House, Assembly Street", post_code: "LS2 7DB", number_of_chairs: 20)
      @r5 = Restaurant.create(name: "Chilli White", street_address: "Assembly Street", post_code: "LS2 7DB", number_of_chairs: 51)
      @r6 = Restaurant.create(name: "Peachy Keens", street_address: "Electric Press Building", post_code: "LS2 7DB", number_of_chairs: 96)

      @r7 = Restaurant.create(name: "San Co Co", street_address: "12 New Briggate", post_code: "LS3 6NU", number_of_chairs: 6)
      @r8 = Restaurant.create(name: "Sandinista", street_address: "5 Cross Belgrave Street", post_code: "LS3 6NU", number_of_chairs: 18)
      @r9 = Restaurant.create(name: "Scarbrough Hotel", street_address: "Bishopgate Street", post_code: "LS3 6NU", number_of_chairs: 24)
    end
    it "post code, restaurant num, total chairs, chair pct, name of restaurant in the post code with the most chairs" do

      expect(Restaurant.post_code_data).to eq("potatoes")
    end

    it "returns all db records with ls1 prefix" do

      expect(Restaurant.find_post_codes("LS1")).to eq([@r1, @r2, @r3])
      expect(Restaurant.find_post_codes("LS2")).to eq([@r4, @r5, @r6])
      expect(Restaurant.find_post_codes()).to eq([@r7, @r8, @r9])
    end

    it "returns ls2 chair amounts to calculate percentile data" do


      expect(Restaurant.percentile_data).to eq([20, 51, 96])
    end

    it "Creates a query that returns the columns, category, total_places, and total_chairs" do
      # "ls1 small"
      Restaurant.create(name: "Small restaurant 1", street_address: "Waterloo House, Assembly Street", post_code: "LS1 7DB", number_of_chairs: 9, category: "ls1 small")
      Restaurant.create(name: "Small Restaurant 2", street_address: "1221 Hedge Lane", post_code: "LS1 7DC", number_of_chairs: 5, category: "ls1 small")
      Restaurant.create(name: "Small restaurant 3", street_address: "5554 West 35th ave", post_code: "LS1 7DB", number_of_chairs: 7, category: "ls1 small")

      # "ls1 medium"
      Restaurant.create(name: "Medium restaurant 1", street_address: "address medium 1", post_code: "LS1 7DB", number_of_chairs: 22, category: "ls1 medium")
      Restaurant.create(name: "Medium restaurant 2", street_address: "address medium 2", post_code: "LS1 7DB", number_of_chairs: 34, category: "ls1 medium")
      Restaurant.create(name: "Medium restaurant 3", street_address: "address medium 3", post_code: "LS1 7DB", number_of_chairs: 19, category: "ls1 medium")

      # "ls1 large"
      Restaurant.create(name: "Large restaurant 1", street_address: "address large 1", post_code: "LS1 7DB", number_of_chairs: 100, category: "ls1 large")
      Restaurant.create(name: "Large restaurant 2", street_address: "address large 2", post_code: "LS1 7DB", number_of_chairs: 122, category: "ls1 large")


      # "ls2 small"
      Restaurant.create(name: "small restaurant ls2 1", street_address: "ls2 address small 1", post_code: "LS2 7DB", number_of_chairs: 1, category: "ls2 small")
      Restaurant.create(name: "small restaurant ls2 2", street_address: "ls2 address small 2", post_code: "LS2 7DB", number_of_chairs: 3, category: "ls2 small")
      Restaurant.create(name: "small restaurant ls2 3", street_address: "ls2 address small 3", post_code: "LS2 7DB", number_of_chairs: 5, category: "ls2 small")

      "ls2 large"
      Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 27, category: "ls2 large")
      Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 33, category: "ls2 large")


      "other"
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")

      expect(Restaurant.organize_by_category).to eq("not sure yet")
    end
  end

  describe "Aggregate cafes" do
    it "Returns restaurants categorized as small" do
      Restaurant.create(name: "Small restaurant 1", street_address: "Waterloo House, Assembly Street", post_code: "LS1 7DB", number_of_chairs: 9, category: "ls1 small")
      Restaurant.create(name: "Small Restaurant 2", street_address: "1221 Hedge Lane", post_code: "LS1 7DC", number_of_chairs: 5, category: "ls1 small")
      Restaurant.create(name: "Small restaurant 3", street_address: "5554 West 35th ave", post_code: "LS1 7DB", number_of_chairs: 7, category: "ls1 small")

      # "ls1 medium"
      Restaurant.create(name: "Medium restaurant 1", street_address: "address medium 1", post_code: "LS1 7DB", number_of_chairs: 22, category: "ls1 medium")
      Restaurant.create(name: "Medium restaurant 2", street_address: "address medium 2", post_code: "LS1 7DB", number_of_chairs: 34, category: "ls1 medium")
      Restaurant.create(name: "Medium restaurant 3", street_address: "address medium 3", post_code: "LS1 7DB", number_of_chairs: 19, category: "ls1 medium")

      # "ls1 large"
      Restaurant.create(name: "Large restaurant 1", street_address: "address large 1", post_code: "LS1 7DB", number_of_chairs: 100, category: "ls1 large")
      Restaurant.create(name: "Large restaurant 2", street_address: "address large 2", post_code: "LS1 7DB", number_of_chairs: 122, category: "ls1 large")


      # "ls2 small"
      Restaurant.create(name: "small restaurant ls2 1", street_address: "ls2 address small 1", post_code: "LS2 7DB", number_of_chairs: 1, category: "ls2 small")
      Restaurant.create(name: "small restaurant ls2 2", street_address: "ls2 address small 2", post_code: "LS2 7DB", number_of_chairs: 3, category: "ls2 small")
      Restaurant.create(name: "small restaurant ls2 3", street_address: "ls2 address small 3", post_code: "LS2 7DB", number_of_chairs: 5, category: "ls2 small")

      "ls2 large"
      Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 27, category: "ls2 large")
      Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 33, category: "ls2 large")


      "other"
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")

      expect(Restaurant.small_street_cafes).to eq(5)
    end
  end
end
# category: The category column
# total_places: The number of places in that category
# total_chairs: The total chairs in that category
