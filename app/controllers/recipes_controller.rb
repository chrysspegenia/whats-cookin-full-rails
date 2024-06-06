class RecipesController < ApplicationController
  before_action :set_recipes

  layout "dashboard_layout"

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

  def save_ingredient
    @recipe = Recipe.find_by(title: params[:title])
    ingredients_array = @recipe.ingredients
  
    # Set the inventory
    set_inventory
  
    if @inventory.present?
      ingredients_array.each do |ingredient_params|
        ingredient_params = ActionController::Parameters.new(name: ingredient_params["food"], quantity: ingredient_params["quantity"])
        ingredient_params.permit!  # Permit all parameters
        @ingredient = @inventory.ingredients.build(ingredient_params)
        @ingredient.quantity = 1 if @ingredient.quantity.nil? || @ingredient.quantity == 0
        @ingredient.user = current_user

        # check if ingredient already exists in inventory
        existing_ingredient = @inventory.ingredients.find_by(name: @ingredient.name)
        if existing_ingredient
          existing_ingredient.quantity += @ingredient.quantity
          if existing_ingredient.save
            flash[:notice] ||= []
            flash[:notice] << "#{ingredient_params["food"]} saved successfully."
          else
            flash[:alert] ||= []
            flash[:alert] << "#{ingredient_params["food"]} failed to save."
          end
        else
          if @ingredient.save
            flash[:notice] ||= []
            flash[:notice] << "#{ingredient_params["food"]} saved successfully."
          else
            flash[:alert] ||= []
            flash[:alert] << "#{ingredient_params["food"]} failed to save."
          end
        end
      end
    else
      flash[:alert] = "Inventory not found."
    end
  end
  
  
  

  private

  def set_recipes
    @recipes = current_user.recipes
  end

  def recipe_params
    params.require(:recipe).permit(:title, :instructions, :image_url, { health_labels: [] }, :calories, { cuisine_type: [] }, { meal_type: [] }, :serving, :url_source, :isUserCreated)
  end

  def filtered_recipe_params
    filtered_params = recipe_params
    filtered_params[:cuisine_type] = filtered_params[:cuisine_type].reject(&:blank?) if filtered_params[:cuisine_type].is_a?(Array)
    filtered_params[:health_labels] = filtered_params[:health_labels].reject(&:blank?) if filtered_params[:health_labels].is_a?(Array)
    filtered_params[:meal_type] = filtered_params[:meal_type].reject(&:blank?) if filtered_params[:meal_type].is_a?(Array)
    if filtered_params[:instructions].present?
      filtered_params[:instructions] = filtered_params[:instructions].split("\n")
    end
    filtered_params[:image_url] = "https://via.placeholder.com/150" if filtered_params[:image_url].blank?
    filtered_params[:isUserCreated] = true
    filtered_params
  end

  def set_inventory
    @inventory = current_user.inventory
  end
end
