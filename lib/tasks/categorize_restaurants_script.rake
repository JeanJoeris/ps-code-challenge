require 'csv'

namespace :import do
  desc "Using initial csv data to categorize existing restaurants"
  task categorize_restaurants: :environment do
    CSV.foreach('./data/street_cafes_2015-16.csv', headers: true) do |row|
      row_data = row.to_h

      puts row_data


#       If the Post Code is of the LS1 prefix type:
# # of chairs less than 10: category = 'ls1 small'
# # of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'
# # of chairs greater than or equal to 100: category = 'ls1 large'
# If the Post Code is of the LS2 prefix type:
# # of chairs below the 50th percentile for ls2: category = 'ls2 small'
# # of chairs above the 50th percentile for ls2: category = 'ls2 large'
# For Post Code is something else:
# category = 'other'

    end
  end
end
