class DashboardController < ApplicationController
    
    layout "dashboard_layout"

    def index
      @recipes = current_user.recipes
    end

  end
  