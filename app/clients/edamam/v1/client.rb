require 'faraday'
require 'json'

class Edamam::V1::Client
  BASE_URL = 'https://api.edamam.com'
  APP_ID = Rails.application.credentials.edamam[:app_id]
  APP_KEY = Rails.application.credentials.edamam[:app_key]
  TYPE = 'public'

  def recipes(params)
    response = request(
      method: :get,
      endpoint: 'api/recipes/v2',
      params: params
    )
    process_recipes(response['hits'])
  end

  def recipe(id)
    response = request(
      method: :get,
      endpoint: "api/recipes/v2/#{id}",
    )
    process_recipe(response['recipe'])
  end

  private

  def request(method:, endpoint:, params: {}, headers: {}, body: {})
    response = connection.public_send(method, endpoint) do |req|
      req.params = { app_id: APP_ID, app_key: APP_KEY, type: TYPE }.merge(params)
      req.headers = headers unless headers.empty?
      req.body = body.to_json unless body.empty?
    end

    return JSON.parse(response.body) if response.success?
    raise "#{response.status}: #{response.body}"
  end

  def process_recipes(data)
    data.map do |recipe_data|
      process_recipe(recipe_data['recipe'])
    end
  end

  def process_recipe(data)
    {
      id: data['uri'].split('#').last,
      title: data['label'],
      image: data['image'],
      url_source: data['url'],
      health_labels: data['healthLabels'],
      ingredients: data['ingredients'],
      calories: data['calories'],
      cuisine_type: data['cuisineType'],
      serving: data["yield"]
    }
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL)
  end
end
