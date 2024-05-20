class Spoonacular::V1::Client

    BASE_URL = 'https://api.spoonacular.com'
    API_KEY = "cd29d8e541254a4ab9243f8f5cda4e9a"
  
    def recipes(**params)
      request(
          method: :get,
          endpoint: "recipes/complexSearch",
          params: params
      )
    end
  
    def recipe_by_ingredients(**params)
      request(
          method: :get,
          endpoint: "recipes/findByIngredients",
          params: params
      )
    end

    private
  
    def request(method:, endpoint:, params: {}, headers: {}, body: {})
      response = connection.public_send(method, "#{endpoint}") do |request|
        request.params = { apiKey: API_KEY }.merge(params)
        request.headers = headers   if headers.present?
        request.body = body.to_json if body.present?
      end
  
      return response.body if response.success?
      # return JSON.parse(response.body).with_indifferent_access if response.success?
      # raise ERROR_CODES[response.status]
      raise "#{response.status}: #{response.body}" 
    end
  
    def connection
      @connection ||= Faraday.new(url: BASE_URL)
    end
  end