class EdamamController < ApplicationController
    
    def index
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
      flash[:alert] = { error: e.message, status: :unprocessable_entity }
      redirect_to edamam_index_path
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
      query = search_params[:title]
      allergies = search_params[:allergies]&.select { |_, v| v == '1' }&.keys || []
      cuisine_type = search_params[:cuisine_type]
  
      # Build search parameters hash conditionally
      search_options = {}
      search_options[:q] = query if query.present?
      search_options[:health] = allergies.join(",") if allergies.present?
      search_options[:cuisineType] = cuisine_type if cuisine_type.present?

      # Pass the hash to the client.recipes method
      client.recipes(search_options)
    end

    def client
      Edamam::V1::Client.new
    end
  end
  