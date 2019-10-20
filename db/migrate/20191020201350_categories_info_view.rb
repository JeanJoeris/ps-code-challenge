class CategoriesInfoView < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
        CREATE VIEW categories_info
              AS
                SELECT restaurants.category              AS category,
                       Count(restaurants.post_code)      AS total_places,
                       Sum(restaurants.number_of_chairs) AS total_chairs
                FROM   restaurants
                GROUP  BY restaurants.category;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP VIEW IF EXISTS categories_info;
        SQL
      end
    end
  end
end
