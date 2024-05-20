class RecipesController < ApplicationController
  
    def recipes
      @recipes = client.recipes(query: "chicken", addRecipeInstructions: true, addRecipeInformation: true, addRecipeNutrition: true)
      render json: @recipes, each_serializer: RecipeSerializer
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  
    private
  
    def client
      Spoonacular::V1::Client.new
    end
  end
  