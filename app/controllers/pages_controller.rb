class PagesController < ApplicationController
  def home
    @title = 'Home'
  end

  def users
    @title = 'Users'
  end
end
