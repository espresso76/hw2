class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    if @selected_ratings==nil
     @selected_ratings = {}
     @all_ratings.each{|el| @selected_ratings[el]=false}
    end
    
    if params[:ratings]!=nil
      @rating_filter = params[:ratings].keys
      for i in 0..(@all_ratings.length-1)
        @selected_ratings[@all_ratings[i]] = @rating_filter.include? @all_ratings[i]
      end
    else
      @rating_filter = []
    end
    @ratings_for_url = {}
    @rating_filter.each {|el| @ratings_for_url["ratings[#{el}]"]=1}
    logger.debug(@rating_filter.inspect)
    logger.debug(@selected_ratings.inspect)
    #if @rating_filter.length==0
    #  @movies = Movie.find(:all, :order => params[:sort])
    #else
    @movies = Movie.find(:all, :conditions => ["rating in (?)", @rating_filter], :order => params[:sort])
    #end

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
