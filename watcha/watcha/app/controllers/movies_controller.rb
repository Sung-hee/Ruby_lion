class MoviesController < ApplicationController
  # 양민은 관리자 페이지에서 나가라 !
  before_action :get_out, except: [:index, :show, :review]

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
  end

  def create
    Movie.create(
      title: params[:title],
      poster: params[:poster],
      genre: params[:genre],
      nation: params[:nation],
      director: params[:director]
    )
    redirect_to root_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def review
    Review.create(
      rating: params[:rating],
      comment: params[:comment],
      user_id: current_user.id,
      movie_id: params[:id]
    )
    redirect_to :back
  end
end
