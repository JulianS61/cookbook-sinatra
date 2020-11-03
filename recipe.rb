class Recipe
  attr_reader :name, :description, :rating, :prep_time, :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating] || 'No Rating'
    @prep_time = attributes[:prep_time] || '0 min'
    @done = attributes[:done] || false
  end

  def done?
    @done
  end

  def mark_done!
    @done = true
  end
end
