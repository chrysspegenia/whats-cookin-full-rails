class RecipesController < ApplicationController
  
    def recipes
      @recipes = client.recipes(query: "pork", addRecipeInstructions: true, addRecipeInformation: true, addRecipeNutrition: true)
    rescue StandardError => e
      @error = e.message
    end
  
    # def show
    #     @recipe = client.recipe_by_ingredients(params[:id], addRecipeInstructions: true, addRecipeInformation: true, addRecipeNutrition: true)
    #   rescue StandardError => e
    #     render json: { error: e.message }, status: :unprocessable_entity
    #   end

    private
  
    def client
      Spoonacular::V1::Client.new
    end
  end
  