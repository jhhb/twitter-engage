

class RequestsController < ApplicationController

  def index

  end

  def home

    r = RequestService.new
    @client = r.configure_twitter

  end




end
