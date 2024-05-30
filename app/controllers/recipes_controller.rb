class RecipesController < ApplicationController
  before_action :set_recipes

  layout "dashboard_layout"

  def recipes
    @recipes = client.recipes(query: "pork", addRecipeInstructions: true, addRecipeInformation: true, addRecipeNutrition: true)
  rescue StandardError => e
    @error = e.message
  end

  def user_recipes
    @recipes
  end

  private

  def client
    Spoonacular::V1::Client.new
  end

  def set_recipes
    @recipes = current_user.recipes
  end
end
