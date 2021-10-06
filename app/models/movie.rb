class Movie < ActiveRecord::Base

  def self.all_ratings
    self.uniq.pluck(:rating)
  end

  def self.with_ratings(ratings_list)
    logger.debug "Rating list #{ratings_list}"
    if ratings_list.nil? or ratings_list.empty?
      return self.all
    end
    self.where(rating: ratings_list)
  end
end
