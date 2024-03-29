require 'csv'
require 'pry'

namespace :export do
  task small_street_cafes: :environment do
     small_street_cafes = Restaurant.small_street_cafes
     file_name = 'small_street_cafes.csv'
     csv_data = small_street_cafes.to_csv
     File.write(file_name, csv_data)

     small_street_cafes.delete_all
  end
end
