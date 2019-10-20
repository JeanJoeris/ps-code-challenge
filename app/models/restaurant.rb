class Restaurant < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :post_code,
                        :number_of_chairs


  def self.post_code_data
    binding.pry
    self.select("restaurants.post_code as post_code, count(restaurants.post_code) as total_places, sum(restaurants.number_of_chairs) as total_chairs, (CAST(sum(restaurants.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM restaurants) as Float) * 100) as chairs_pct, MAX(number_of_chairs) as max_chairs").group("post_code")
  end


  def self.total_chairs
    self.select(:name).where(post_code: "LS2 7DB")
    self.select(:name).where(post_code: "LS2 7DB").order("restaurants.number_of_chairs desc").limit(1)
    "(SELECT restaurants.name FROM restaurants WHERE restaurants.post_code = post_code ORDER BY restaurants.number_of_chairs desc LIMIT 1) as place_with_max_chairs"
  end

end

SELECT restaurants.post_code as post_code, count(restaurants.post_code) as total_places, sum(restaurants.number_of_chairs) as total_chairs, (CAST(sum(restaurants.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM restaurants) as Float) * 100) as chairs_pct, MAX(number_of_chairs) as max_chairs FROM restaurants GROUP BY restaurants.post_code;
