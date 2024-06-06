module MealPlannerHelper
    private
  
    def recipe_options
      current_user.recipes.map { |recipe| [recipe.title, recipe.id] }
    end
    
  end
  