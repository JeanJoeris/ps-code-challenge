class PostCodeInfoView < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
        CREATE VIEW post_code_info
              AS
              WITH summary AS (
                SELECT
                    r.post_code,
                    r.number_of_chairs,
                    r.name,
                    ROW_NUMBER() OVER(PARTITION BY r.post_code ORDER BY r.number_of_chairs DESC) as rk
                 FROM restaurants r)
              SELECT s.post_code, agg_tbl.total_places, agg_tbl.total_chairs, agg_tbl.chairs_pct, s.name as place_with_max_chairs, s.number_of_chairs as max_chairs
              FROM summary s
              INNER JOIN (SELECT post_code,
                                   SUM(number_of_chairs) as total_chairs,
                                   (CAST(sum(restaurants.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM restaurants) as Float) * 100) as chairs_pct,
                                   count(restaurants.post_code) as total_places
                                   FROM restaurants GROUP BY post_code) agg_tbl ON (agg_tbl.post_code = s.post_code)
              WHERE s.rk = 1;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP VIEW IF EXISTS post_code_info;
        SQL
      end
    end
  end
end
