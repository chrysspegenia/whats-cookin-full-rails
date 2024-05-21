class EdamamController < ApplicationController
    # before_action :set_recipe, only: [:show]
  
    def index
      @recipes = client.recipes(q: "chicken")
    rescue StandardError => e
      flash[:alert] = { error: e.message, status: :unprocessable_entity }
    end
  
    private
  
    def client
      Edamam::V1::Client.new
    end
  end
  