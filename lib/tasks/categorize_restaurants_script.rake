require 'csv'
require 'pry'

namespace :import do
  desc "Using initial csv data to categorize existing restaurants"
  task categorize_restaurants: :environment do
    @ls1_restaurants = Restaurant.find_post_codes("LS1")
    @ls2_restaurants = Restaurant.find_post_codes("LS2")
    @other_restaurants = Restaurant.find_post_codes()

    def percentile_50
      percentile_data = Restaurant.percentile_data(@ls2_restaurants)
      index = (percentile_data.length * 0.5)
      if index.floor == index
        (percentile_data[index.to_i - 1] + percentile_data[index.to_i]) / 2.0
      else
        percentile_data[index.ceil - 1]
      end
    end



    percentile_50

    binding.pry

    # ls1_restaurants.each do |restaurant|
    #   chair_count = restaurant.number_of_chairs
    #   if chair_count < 10
    #     restaurant.update_column(:category, 'ls1 small')
    #   elsif chair_count >= 10 && chair_count < 100
    #     restaurant.update_column(:category, 'ls1 medium')
    #   elsif chair_count >= 100
    #     restaurant.update_column(:category, 'ls1 large')
    #   end
    # end






  end
end

#
# def handle_ls1(row_data)
#
#
#   if row_data["Number of Chairs"].to_i < 10
#     restaurant.update_column(:category, 'ls1 small')
#   elsif row_data["Number of Chairs"].to_i >= 10 && row_data["Number of Chairs"].to_i < 100
#     restaurant.update_column(:category, 'ls1 medium')
#   elsif row_data["Number of Chairs"].to_i >= 100
#     restaurant.update_column(:category, 'ls1 large')
#   end
# end

# def collect_chair_count(row_data, chair_amounts = [])
#   chair_amounts = []
#   binding.pry
# end
#
# def handle_other(row_data)
#   puts "other code"
# end

# WITH summary AS (
#     SELECT
#         r.id,
#         r.post_code,
#         r.number_of_chairs,
#         r.name,
#         ROW_NUMBER() OVER(PARTITION BY( r.post_code ORDER BY r.number_of_chairs DESC)) as rk
#      FROM restaurants r)
# SELECT s.*
# FROM summary s
# WHERE s.rk = 1;
