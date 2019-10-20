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

    @ls1_restaurants.each do |restaurant|
      chair_count = restaurant.number_of_chairs
      if chair_count < 10
        restaurant.update_column(:category, 'ls1 small')
      elsif chair_count >= 10 && chair_count < 100
        restaurant.update_column(:category, 'ls1 medium')
      elsif chair_count >= 100
        restaurant.update_column(:category, 'ls1 large')
      end
    end

    @ls2_restaurants.each do |restaurant|
      if restaurant.number_of_chairs < percentile_50
        restaurant.update_column(:category, 'ls2 small')
      elsif restaurant.number_of_chairs > percentile_50
        restaurant.update_column(:category, 'ls2 large')
      end
    end

    @other_restaurants.each do |restaurant|
      restaurant.update_column(:category, "other")
    end
  end

end
