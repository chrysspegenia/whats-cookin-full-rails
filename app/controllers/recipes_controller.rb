class RecipesController < ApplicationController
  before_action :set_recipes

  layout "dashboard_layout"

  def recipes
    @recipes = client.recipes(query: "pork", addRecipeInstructions: true, addRecipeInformation: true, addRecipeNutrition: true)
  rescue StandardError => e
    @error = e.message
  end

  def saved_recipes
    @saved_recipes = current_user.recipes.where(isUserCreated: false || nil)
  end

  def user_recipes
    @user_created_recipes = current_user.recipes.where(isUserCreated: true)
  end

  def show
    @recipe = Recipe.find_by(title: params[:title])
    if @recipe.nil?
      redirect_to recipes_path, alert: "Recipe not found."
    end
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(filtered_recipe_params)
    if @recipe.save
      redirect_to myrecipes_path, notice: "Recipe was successfully created."
    else
      render :new
    end
  end

  private

  def client
    Spoonacular::V1::Client.new
  end

  def set_recipes
    @recipes = current_user.recipes
  end

  def recipe_params
    params.require(:recipe).permit(:title, :instructions, :image_url, { health_labels: [] }, :calories, { cuisine_type: [] }, { meal_type: [] }, :serving, :url_source, :isUserCreated)
  end

  def filtered_recipe_params
    filtered_params = recipe_params
    filtered_params[:cuisine_type] = filtered_params[:cuisine_type].reject(&:blank?) if filtered_params[:cuisine_type].is_a?(Array)
    filtered_params[:meal_type] = filtered_params[:meal_type].reject(&:blank?) if filtered_params[:meal_type].is_a?(Array)
    if filtered_params[:instructions].present?
      filtered_params[:instructions] = filtered_params[:instructions].split("\n")
    end
    filtered_params[:image_url] = "https://via.placeholder.com/150" if filtered_params[:image_url].blank?
    filtered_params[:isUserCreated] = true
    filtered_params
  end
end
