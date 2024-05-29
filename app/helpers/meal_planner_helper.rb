module MealPlannerHelper
    def meal_select_options(is_today)
      content_tag(:div) do
        3.times.map do
          select_tag("", options_for_select(recipe_options, selected: ""), include_blank: true, class: is_today ? 'dropdown' : 'colored-dropdown')
        end.join.html_safe
      end
    end
  
    private
  
    def recipe_options
      @recipes.map { |recipe| [recipe.title, recipe.id] }
    end
  end
  