class PagesController < ApplicationController
  def welcome
    render 'welcome'
  end

  def about
    render 'about'
  end

  def contact
    render 'contact'
  end
end
