class Restaurant < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :post_code,
                        :number_of_chairs

  # method used to return all restaurants with a specified prefix for categorization
  def self.find_post_codes(prefix = nil)
    if prefix
      Restaurant.where("post_code LIKE ?", "#{prefix}%")
    else
      Restaurant.where.not("post_code LIKE 'LS1%' OR post_code LIKE 'LS2%'")
    end
  end

  #method used in the script to categorize medium and large restaurants
  def self.percentile_data(prefix)
    Restaurant.where("post_code LIKE ?", "#{prefix}%").select("number_of_chairs").pluck("number_of_chairs")
  end

  #method used in the script to categorize medium and large restaurants
  def self.return_med_and_large
    Restaurant.where("category LIKE '%medium' OR category LIKE '%large'")
  end

  #method used in the script to categorize small restaurants
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

end
