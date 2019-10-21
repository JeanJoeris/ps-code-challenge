class Restaurant < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :post_code,
                        :number_of_chairs


  def self.post_code_data
    self.select("restaurants.post_code as post_code, count(restaurants.post_code) as total_places, sum(restaurants.number_of_chairs) as total_chairs, (CAST(sum(restaurants.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM restaurants) as Float) * 100) as chairs_pct, restaurants.name as place_with_max_chairs, MAX(number_of_chairs) as max_chairs").group("post_code").group("restaurants.name")
  end

  def self.find_post_codes(prefix = nil)
    if prefix
      Restaurant.where("post_code LIKE ?", "#{prefix}%")
    else
      Restaurant.where.not("post_code LIKE 'LS1%' OR post_code LIKE 'LS2%'")
    end
  end

  def self.percentile_data(prefix)
    Restaurant.where("post_code LIKE ?", "#{prefix}%").select("number_of_chairs").pluck("number_of_chairs")
  end

  def self.organize_by_category
    self.select("restaurants.category as category, count(restaurants.post_code) as total_places, sum(restaurants.number_of_chairs) as total_chairs").group("category")
  end

  # organize_by_category in sql
  def category_table
    "SELECT restaurants.category as category, count(restaurants.post_code) as total_places, sum(restaurants.number_of_chairs) as total_chairs FROM restaurants GROUP BY restaurants.category;"
  end

  def self.small_street_cafes
    Restaurant.where("category LIKE ?", "%small").all
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv_file|
      csv_file << csv_header_row

      all.each do |restaurant|
        csv_file << restaurant.to_csv
      end
    end
  end

  def to_csv
    [id, name, street_address, post_code, number_of_chairs, category]
  end

  def self.csv_header_row
    %w(ID Name Street_Address Post_Code Number_of_chairs Category)
  end

  def self.return_med_and_large
    Restaurant.where("category LIKE '%medium' OR category LIKE '%large'")
  end
end


# CREATE VIEW categories_info AS SELECT restaurants.category as category, count(restaurants.post_code) as total_places, sum(restaurants.number_of_chairs) as total_chairs FROM restaurants GROUP BY restaurants.category;

# SELECT restaurants.post_code as post_code, count(restaurants.post_code) as total_places, sum(restaurants.number_of_chairs) as total_chairs, (CAST(sum(restaurants.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM restaurants) as Float) * 100) as chairs_pct, MAX(number_of_chairs) as max_chairs FROM restaurants GROUP BY restaurants.post_code;
