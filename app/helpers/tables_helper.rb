module TablesHelper
  def show_prev
    @page_number && @page_number > 1
  end

  def show_next
    @page_number && @tweets.length == @tweets_per_page
  end
end