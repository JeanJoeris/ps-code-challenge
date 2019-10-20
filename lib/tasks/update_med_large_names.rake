require 'csv'
require 'pry'

namespace :import do
  desc "concatenate category name to med and large restaurants"
  task update_names: :environment do

  med_and_large_cafes = Restaurant.return_med_and_large

    med_and_large_cafes.each do |restaurant|
      new_name = "#{restaurant.category} #{restaurant.name}"
      restaurant.update_column(:name, new_name)
    end
  end
end
