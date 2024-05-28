class MealPlannerController < ApplicationController

    layout "dashboard_layout"

    def index
        @recipes = Recipe.all
    end
end
