class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    logger.debug "Params: #{params}"
    @all_ratings = Movie.all_ratings
    if params["commit"] == "Refresh"
      session.clear
    end
    if params.key? "ratings"
      session["ratings"] = params["ratings"]
    end
    if params.key? "sort_by"
      session["sort_by"] = params["sort_by"]
    end
    @ratings_to_show = []
    if session.key? "ratings"
        @ratings_to_show = session["ratings"].keys
    end
    @sort_by = nil
    if session.key? "sort_by"
      @sort_by = session["sort_by"]
    end
    @movies = Movie.with_ratings(@ratings_to_show, @sort_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
