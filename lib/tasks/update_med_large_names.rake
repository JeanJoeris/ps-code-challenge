require 'csv'
require 'pry'

namespace :import do
  desc "concatenate category name to med and large restaurants"
  task update_names: :environment do
    categorize = Categorize.new
    categorize.concat_name_and_category(Restaurant.return_med_and_large)
  end
end
