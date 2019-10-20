class Categorize

  def initialize()
  end

  def percentile_50(dataset)
    percentile_data = Restaurant.percentile_data(dataset)
    index = (percentile_data.length * 0.5)
    if index.floor == index
      (percentile_data[index.to_i - 1] + percentile_data[index.to_i]) / 2.0
    else
      percentile_data[index.ceil - 1]
    end
  end

  def set_ls1_categories(restaurants)
    restaurants.each do |restaurant|
      chair_count = restaurant.number_of_chairs
      if chair_count < 10
        restaurant.update_column(:category, 'ls1 small')
      elsif chair_count >= 10 && chair_count < 100
        restaurant.update_column(:category, 'ls1 medium')
      elsif chair_count >= 100
        restaurant.update_column(:category, 'ls1 large')
      end
    end
  end

  def set_ls2_categories(restaurants, percentile)
    restaurants.each do |restaurant|
      if restaurant.number_of_chairs < percentile
        restaurant.update_column(:category, 'ls2 small')
      elsif restaurant.number_of_chairs > percentile
        restaurant.update_column(:category, 'ls2 large')
      end
    end
  end

  def set_other_categories(restaurants)
    restaurants.each do |restaurant|
      restaurant.update_column(:category, "other")
    end
  end

end
