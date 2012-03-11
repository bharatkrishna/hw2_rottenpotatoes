class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    
    # sanitize the rating params hash so that its not a check box hash
    if params[:ratings] && params[:ratings].respond_to?(:keys)
      params[:ratings] = params[:ratings].keys 
    end

    # if the params hash for ratings or sort_by is not set(does not receive anything from the view) 
    # and if the session hash has values, redirect to index with the URI determined by session hash. 
    if !params[:ratings] && !params[:sort_by] && (session[:ratings] || session[:sort_by])
      redirect_to action: 'index', ratings: session[:ratings], sort_by: session[:sort_by]
    end
    
    @all_ratings = Movie.all.map {|m| m.rating }.uniq   # Get all entries, iterate over them, get only ratings,from that get unique ratings
    
    # If session does not exist, initialize the session    
    session[:ratings] ||= @all_ratings
    session[:sort_by] ||= ''
    
    @ratings = params["ratings"] ? params["ratings"] : session[:ratings]   #if params["rating"] is  nil, then get it's value from the session
    
    # Checking if the sort_by value is from the array [title, release_date] so that nothing is done if the user enters a nonexistant word like 'foo' to sort by
    @sort_by = %w(title release_date).index(params[:sort_by]) ? params[:sort_by] : session[:sort_by] 
    
    @movies = Movie.order(@sort_by).find_all_by_rating(@ratings) #.find(:all, :order => params[:sort])   
    
    session[:ratings] = @ratings
    session[:sort_by] = @sort_by
     
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
