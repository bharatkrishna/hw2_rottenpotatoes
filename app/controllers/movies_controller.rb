class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    
    @all_ratings = Movie.all.map {|m| m.rating }.uniq # Get all entries, iterate over them, get only ratings,from that get unique ratings
    @ratings = params["ratings"] ? params["ratings"].keys : @all_ratings #if params["rating"] is not nil, then get the keys of that hash
    
    # Checking if the sort_by value is from the array [title, release_date] so that nothing is done if the user enters a nonexistant word like 'foo' to sort by
    @sort_by = %w(title release_date).index(params[:sort_by]) ? params[:sort_by] : ''
    
    @movies = Movie.order(@sort_by).find_all_by_rating(@ratings) #.find(:all, :order => params[:sort])    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
