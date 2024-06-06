module MealPlannerHelper
    private
  
    def recipe_options
      current_user.recipes.map do |recipe|
        {
          id: recipe.id,
          title: recipe.title,
          image_url: recipe.image_url,
          meal_type: recipe.meal_type,
          cuisine_type: recipe.cuisine_type
        }
      end
    end
    
    
  end
  