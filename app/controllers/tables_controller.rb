class TablesController < ApplicationController

  def index
    @tweets_per_page = 25
    @total_tweets = Tweet.all.count
    @tweets = Tweet.first(@tweets_per_page)
  end

  def filter
    @tweets_per_page = params[:number_of_results].to_i

    page_number = params[:page_number].to_i

    @total_tweets = Tweet.all.count

    @tweets ||= Tweet.first(@tweets_per_page)

    if page_number != 0
      puts page_number
      @tweets = Tweet.limit(@tweets_per_page).offset(@tweets_per_page * (page_number - 1))
    else
      page_number = 1
    end

    @page_number = page_number

    render 'index'
  end

  private

    def table_params
      params.require(:table).permit(:page_number, :next, :previous)
    end

end
