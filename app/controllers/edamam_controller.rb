class EdamamController < ApplicationController
    
  layout "dashboard_layout"

    def index
      @ingredients = current_user.ingredients

      if params[:search].present?
        @recipes = perform_search(params[:search])
      end
    rescue StandardError => e
      flash[:alert] = { error: e.message, status: :unprocessable_entity }
      @recipes = []
    end

    def show
      @recipe = client.recipe(params[:id])
      @recipe_url = @recipe[:url_source]
      @recipe_name = @recipe[:title]
      @ingredients = @recipe[:ingredients]
      
      # Rails.logger.debug "Recipe URL: #{@recipe_url}"
      # Rails.logger.debug "Recipe Name: #{@recipe_name}"
      # Rails.logger.debug "Ingredients: #{@ingredients}"
    
      @instructions = RecipeService.fetch_recipe_instructions(@recipe_url, @recipe_name, @ingredients)

      # Rails.logger.debug "instructions from controller: #{@instructions}"
    rescue StandardError => e
      Rails.logger.error "Error in show action: #{e.message}"
      redirect_to edamam_index_path
    end

    def save_recipe
      @recipe = params[:recipe]
      @instructions = params[:instructions]
  
      existing_recipe = Recipe.find_by(title: @recipe[:title],url_source: @recipe[:url_source], user_id: current_user.id)
      if existing_recipe
        flash[:alert] = 'This recipe is already in your collection.'
        redirect_to edamam_path(@recipe[:id])
        return
      end

      @new_recipe = Recipe.new(
        title: @recipe[:title],
        image_url: @recipe[:image],
        url_source: @recipe[:url_source],
        health_labels: @recipe[:health_labels],
        calories: @recipe[:calories],
        cuisine_type: @recipe[:cuisine_type],
        meal_type: @recipe[:meal_type],
        serving: @recipe[:serving],
        instructions: @instructions,
        user_id: current_user.id,
        ingredients: @recipe[:ingredients],
        isUserCreated: false
      )
  
      if @new_recipe.save
        save_ingredient(@recipe)
        flash[:notice] = 'Recipe added to your collection.'
        redirect_to edamam_path(@recipe[:id])
      else
        flash[:alert] = 'Recipe could not be added.'
        redirect_to edamam_path(@recipe[:id])
      end
    end

    def fetch_instructions
      recipe_url = params[:url_source]
      @recipe_data = RecipeService.fetch_recipe_instructions(recipe_url)
  
      if @recipe_data[:error]
        redirect_to edamam_index_path
      end

    end

    private

    def perform_search(search_params)
      title = search_params[:title] 
      ingredients = search_params[:ingredients]&.select { |_, v| v == '1' }&.keys || []
      allergies = search_params[:allergies]&.select { |_, v| v == '1' }&.keys || []
      cuisine_type = search_params[:cuisine_type]
  
      query = [title, *ingredients].join(" ")
      # Build search parameters hash conditionally
      search_options = {}
      search_options[:q] = query if query.present?
      search_options[:health] = allergies.join(",") if allergies.present?
      search_options[:cuisineType] = cuisine_type if cuisine_type.present?

      puts query
      # Pass the hash to the client.recipes method
      client.recipes(search_options)
    end

    def client
      Edamam::V1::Client.new
    end

    def save_ingredient(saved_recipe)
      ingredients_array = saved_recipe[:ingredients]
    
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
            @ingredient.is_grocery_item = true
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

    def set_inventory
      @inventory = current_user.inventory
    end
  end
  