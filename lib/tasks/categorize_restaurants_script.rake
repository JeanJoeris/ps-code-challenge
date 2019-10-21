require 'csv'
require 'pry'

namespace :import do
  desc "Using initial csv data to categorize existing restaurants"
  task categorize_restaurants: :environment do

    categorize = Categorize.new
    ls2_restaurants = Restaurant.find_post_codes("LS2")

    categorize.set_ls1_categories(Restaurant.find_post_codes("LS1"))
    categorize.set_ls2_categories(Restaurant.find_post_codes("LS2"), categorize.percentile_50("LS2"))
    categorize.set_other_categories(Restaurant.find_post_codes())

  end
end
