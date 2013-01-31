class HomeController < ApplicationController
  def index
    set_meta_tag(:title, "Accueil")
  end
end
