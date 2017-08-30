class TablesController < ApplicationController

  # Load the first n tweets on the page (25 by default)
  def index
    @tweets_per_page = 25
    @total_tweets = Tweet.all.count
    @tweets = Tweet.first(@tweets_per_page)
  end

  # Summary:  This function is called when a user filters the number of tweets.
  #           It needs to determine the page number to display, the number of tweets per page to show (used in view),
  #           and which tweets to actually display.
  def filter
    @tweets_per_page = params[:number_of_results].to_i
    page_number = params[:page_number].to_i
    @total_tweets = Tweet.all.count

    @tweets = []

    # if we are on a page that isn't the first, we offset the tweets
    if page_number != 0
      @tweets = Tweet.limit(@tweets_per_page).offset(@tweets_per_page * (page_number - 1))
    else
      # otherwise we set page number to 1 so we don't display page 0
      @tweets = Tweet.first(@tweets_per_page)
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