class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    sdfsdfs
  end

  def kitchensink
  end
end
