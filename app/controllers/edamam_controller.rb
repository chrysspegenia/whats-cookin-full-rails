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
    rescue StandardError => e
      flash[:alert] = { error: e.message, status: :unprocessable_entity }
      redirect_to edamam_index_path
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
  