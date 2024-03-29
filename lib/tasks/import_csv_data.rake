require 'csv'

namespace :import do
  desc "Import data from csv file"
  task cafe_data: :environment do
    CSV.foreach('./data/street_cafes_2015-16.csv', headers: true) do |row|
      row_data = row.to_h

      Restaurant.create(name: row_data["Cafe/Restaurant Name"],
                        street_address: row_data["Street Address"],
                        post_code: row_data["Post Code"],
                        number_of_chairs: row_data["Number of Chairs"]
      )

    end
  end
end
