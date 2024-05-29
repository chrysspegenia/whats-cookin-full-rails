require 'faraday'
require 'json'

module Gemini
  module V1
    class Client
      BASE_URI = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent'.freeze

      def initialize
        @api_key = Rails.application.credentials.dig(:gemini, :api_key)
        @connection = Faraday.new(url: BASE_URI) do |conn|
          conn.headers['Content-Type'] = 'application/json'
          conn.adapter Faraday.default_adapter
        end
      end

      def generate_cooking_instructions(recipe_name, ingredients)
        body = {
          "contents": [
            {
              "parts": [
                {
                  "text": "Generate detailed cooking instructions for a recipe called '#{recipe_name}' 
                  using the following ingredients: #{ingredients.join(', ')} in a step by step manner. 
                  Return only the steps (no numbers), each step on a new line, and no extra text or sections."
                }
              ]
            }
          ]
        }

        response = @connection.post("?key=#{@api_key}", body.to_json)
        handle_response(response)
      end

      def organize_cooking_instructions(existing_instructions)
        body = {
          "contents": [
            {
              "parts": [
                {
                  "text": "Organize the following cooking instructions into a clear and structured step-by-step format, 
                  removing any equipment lists,authors,unnecessary wordss or unnecessary notes: '#{existing_instructions}'
                  Return only the steps(no numbers), each step on a new line, and no extra text or sections."
                }
              ]
            }
          ]
        }

        response = @connection.post("?key=#{@api_key}", body.to_json)
        handle_response(response)
      end

      private

      def handle_response(response)
        if response.success?
          # Rails.logger.info "API Response: #{response.body}"
          response_json = JSON.parse(response.body)
          text = response_json.dig('candidates', 0, 'content', 'parts', 0, 'text')
          
          instructions = parse_instructions(text)
          return instructions
        else
          Rails.logger.error "API Request Failed: #{response.status} - #{response.body}"
          []
        end
      end

      def parse_instructions(text)
        lines = text.split("\n")

        # Clean up each instruction line
        instructions = lines.map { |line| line.gsub(/\*\*|\n/, '').strip }.reject(&:empty?)

        instructions
      end
      
      
    end
  end
end
