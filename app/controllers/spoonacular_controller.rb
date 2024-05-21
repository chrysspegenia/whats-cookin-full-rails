class SpoonacularController < ApplicationController
    # before_action :set_recipe, only: [:show]
  
    def index
      @recipes = client.recipes(query: "chicken", addRecipeInstructions: true, addRecipeInformation: true, addRecipeNutrition: true)
    rescue StandardError => e
      flash[:alert] = { error: e.message, status: :unprocessable_entity }
    end
  
    private
  
    def client
      Spoonacular::V1::Client.new
    end

  end
  