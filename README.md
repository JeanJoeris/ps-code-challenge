# Code challenge submission

<h4>Versioning</h4>

<p>This Application was built in (Rails) 5.2.3 and (PostgreSQL) 11.4</p>

<h4>Application Walkthrough</h4>

  - clone the repository
  - cd into the repository
  - run $ ``bundle`` from the command line
  - run $ ``rails db:create`` to create the database
  - run $ ``rails db:migrate`` to create a users table in the database
  - run $ ``rake import:cafe_data`` to import the Street Cafe csv data included in the code challenge repository
  
<ul>
  
  <li>At this point the first view will be available to query with the command ``SELECT * FROM post_code_info;`` The SQL used is as follows </li>

``CREATE VIEW post_code_info
              AS
              WITH summary AS (
                SELECT
                    r.post_code,
                    r.number_of_chairs,
                    r.name,
                    ROW_NUMBER() OVER(PARTITION BY r.post_code ORDER BY r.number_of_chairs DESC) as rk
                 FROM restaurants r)
              SELECT s.post_code, agg_tbl.total_places, agg_tbl.total_chairs, agg_tbl.chairs_pct, s.name as          place_with_max_chairs, s.number_of_chairs as max_chairs
              FROM summary s
              INNER JOIN (SELECT post_code,
                                   SUM(number_of_chairs) as total_chairs,
                                   (CAST(sum(restaurants.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM restaurants) as Float) * 100) as chairs_pct,
                                   count(restaurants.post_code) as total_places
                                   FROM restaurants GROUP BY post_code) agg_tbl ON (agg_tbl.post_code = s.post_code)
              WHERE s.rk = 1;``
              
<li>This statement was verified by breaking up each subquery writing the activerecord equivalent using smaller dummy datasets.</li>
              
  <li>From here run the command ``rake import:categorize_restaurants`` to categorize the dataset according to the specifications.. when the task is finished the second view will be available with the command ``SELECT * FROM categories_info`` The SQL used is as follows </li>

``CREATE VIEW categories_info
              AS
                SELECT restaurants.category              AS category,
                       Count(restaurants.post_code)      AS total_places,
                       Sum(restaurants.number_of_chairs) AS total_chairs
                FROM   restaurants
                GROUP  BY restaurants.category;``
                

<p>This view produces the following table</p>

                      ```  category  | total_places | total_chairs 
                      ------------+--------------+--------------
                       ls1 medium |           50 |         1258
                       ls1 small  |           11 |           64
                       ls2 large  |            5 |          489
                       ls2 small  |            5 |           84
                       ls1 large  |            1 |          152
                       other      |            1 |           32
                      (6 rows)```
                
  <li>Now you can run the task ``rake export:small_street_cafes`` this will generate a csv in the file tree according to the specifications.</li>

  <li>The final task can be run with the command ``rake import:update_names`` this will update all medium and large cafe/restaurants name as a concatenated string with the category prefix before their name.</li>

</ul>

<h4>Testing</h4>

<p>This application is tested using RSpec, to set up, run ``rails g rspec:install`` and then ``rspec``</p>

<h5>Testing the script to categorize restaurants, export small restuarants, and concatenate the names of medium and large restaurants</h5>

<p>``find_post_code()`` method used and tested to return restaurants based on their prefix</p>
<p>``percentile_data()`` method used and tested to supply the dataset necessary to calculate percentiles</p>
<p>``small_street_cafes`` method used and tested to return all restaurants categorized as small</p>
<p>``return_med_and_large`` method used and tested to return all restaurants categorized as medium and large</p>
<p>These methods are all tested in the restaurant model</p>
  



