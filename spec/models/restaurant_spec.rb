require 'rails_helper'

describe Restaurant, type: :model do
  describe "Validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :post_code}
    it {should validate_presence_of :number_of_chairs}
  end

  describe "Model methods" do
    before :each do
      # "ls1 small"
      @r1 = Restaurant.create(name: "Small restaurant 1", street_address: "Waterloo House, Assembly Street", post_code: "LS1 7DB", number_of_chairs: 9, category: "ls1 small")
      @r2 = Restaurant.create(name: "Small Restaurant 2", street_address: "1221 Hedge Lane", post_code: "LS1 7DC", number_of_chairs: 5, category: "ls1 small")
      @r3 = Restaurant.create(name: "Small restaurant 3", street_address: "5554 West 35th ave", post_code: "LS1 7DB", number_of_chairs: 7, category: "ls1 small")

      # "ls1 medium"
      @r4 = Restaurant.create(name: "Medium restaurant 1", street_address: "address medium 1", post_code: "LS1 7DB", number_of_chairs: 22, category: "ls1 medium")
      @r5 = Restaurant.create(name: "Medium restaurant 2", street_address: "address medium 2", post_code: "LS1 7DB", number_of_chairs: 34, category: "ls1 medium")
      @r6 = Restaurant.create(name: "Medium restaurant 3", street_address: "address medium 3", post_code: "LS1 7DB", number_of_chairs: 19, category: "ls1 medium")

      # "ls1 large"
      @r7 = Restaurant.create(name: "Large restaurant 1", street_address: "address large 1", post_code: "LS1 7DB", number_of_chairs: 100, category: "ls1 large")
      @r8 = Restaurant.create(name: "Large restaurant 2", street_address: "address large 2", post_code: "LS1 7DB", number_of_chairs: 122, category: "ls1 large")


      # "ls2 small"
      @r9 = Restaurant.create(name: "small restaurant ls2 1", street_address: "ls2 address small 1", post_code: "LS2 7DB", number_of_chairs: 1, category: "ls2 small")
      @r10 = Restaurant.create(name: "small restaurant ls2 2", street_address: "ls2 address small 2", post_code: "LS2 7DB", number_of_chairs: 3, category: "ls2 small")
      @r11 = Restaurant.create(name: "small restaurant ls2 3", street_address: "ls2 address small 3", post_code: "LS2 7DB", number_of_chairs: 5, category: "ls2 small")

      # "ls2 large"
      @r12 = Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 27, category: "ls2 large")
      @r13 = Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 33, category: "ls2 large")


      # "other"
      @r14 = Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      @r15 = Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      @r16 = Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      @r17 = Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
    end
    it "returns all db records with a specified prefix" do

      expect(Restaurant.find_post_codes("LS1")).to eq([@r1, @r2, @r3, @r4, @r5, @r6, @r7, @r8])
      expect(Restaurant.find_post_codes("LS2")).to eq([@r9, @r10, @r11, @r12, @r13])
      expect(Restaurant.find_post_codes()).to eq([@r14, @r15, @r16, @r17])
    end

    it "returns ls2 chair amounts to calculate percentile data" do

      expect(Restaurant.percentile_data("LS2")).to eq([1, 3, 5, 27, 33])
    end
  end


  describe "Aggregate cafes" do
    it "Returns restaurants categorized as small" do
      @r1 = Restaurant.create(name: "Small restaurant 1", street_address: "Waterloo House, Assembly Street", post_code: "LS1 7DB", number_of_chairs: 9, category: "ls1 small")
      @r2 = Restaurant.create(name: "Small Restaurant 2", street_address: "1221 Hedge Lane", post_code: "LS1 7DC", number_of_chairs: 5, category: "ls1 small")
      @r3 = Restaurant.create(name: "Small restaurant 3", street_address: "5554 West 35th ave", post_code: "LS1 7DB", number_of_chairs: 7, category: "ls1 small")

      # "ls1 medium"
      @m1 = Restaurant.create(name: "Medium restaurant 1", street_address: "address medium 1", post_code: "LS1 7DB", number_of_chairs: 22, category: "ls1 medium")
      @m2 = Restaurant.create(name: "Medium restaurant 2", street_address: "address medium 2", post_code: "LS1 7DB", number_of_chairs: 34, category: "ls1 medium")
      @m3 = Restaurant.create(name: "Medium restaurant 3", street_address: "address medium 3", post_code: "LS1 7DB", number_of_chairs: 19, category: "ls1 medium")

      # "ls1 large"
      @l1 = Restaurant.create(name: "Large restaurant 1", street_address: "address large 1", post_code: "LS1 7DB", number_of_chairs: 100, category: "ls1 large")
      @l2 = Restaurant.create(name: "Large restaurant 2", street_address: "address large 2", post_code: "LS1 7DB", number_of_chairs: 122, category: "ls1 large")


      # "ls2 small"
      @r4 = Restaurant.create(name: "small restaurant ls2 1", street_address: "ls2 address small 1", post_code: "LS2 7DB", number_of_chairs: 1, category: "ls2 small")
      @r5 = Restaurant.create(name: "small restaurant ls2 2", street_address: "ls2 address small 2", post_code: "LS2 7DB", number_of_chairs: 3, category: "ls2 small")
      @r6 = Restaurant.create(name: "small restaurant ls2 3", street_address: "ls2 address small 3", post_code: "LS2 7DB", number_of_chairs: 5, category: "ls2 small")

      # "ls2 large"
      @l3 = Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 27, category: "ls2 large")
      @l4 = Restaurant.create(name: "Large restaurant 2", street_address: "ls2 address large 3", post_code: "LS2 7DB", number_of_chairs: 33, category: "ls2 large")


      # "other"
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")
      Restaurant.create(name: "Other category grill", street_address: "other address 1", post_code: "LS7 7DB", number_of_chairs: 16, category: "other")

      expect(Restaurant.small_street_cafes).to eq([@r1, @r2, @r3, @r4, @r5, @r6])
      expect(Restaurant.return_med_and_large).to eq([@m1, @m2, @m3, @l1, @l2, @l3, @l4])
    end
  end
end
