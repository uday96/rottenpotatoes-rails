class Movie < ActiveRecord::Base

  def self.all_ratings
    self.uniq.pluck(:rating)
  end

  def self.with_ratings(ratings_list, sort_by)
    logger.debug "Rating list: #{ratings_list}"
    logger.debug "Sort by: #{sort_by}"
    if ratings_list.nil? or ratings_list.empty?
       movies = self.all
    else
      movies = self.where(rating: ratings_list)
    end
    if sort_by == "title"
      return movies.order(:title)
    end
    if sort_by == "release_date"
        return movies.order(:release_date)
    end
    return movies
  end
end
