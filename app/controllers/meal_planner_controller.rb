class MealPlannerController < ApplicationController
  layout "dashboard_layout"

  helper_method :week_of_month_label, :date_range

  def index
    @meal_plans = current_user.meal_plans
    @recipes = Recipe.all
    @meal_plan = MealPlan.new
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
  end

  def create
    date = params[:date]
    meal_type = params[:meal_type]
    recipe_id = params[:recipe_id]

    if date.blank? || meal_type.blank? || recipe_id.blank?
      render json: { error: 'Missing required parameters' }, status: :unprocessable_entity
      return
    end

    existing_meal_plans = current_user.meal_plans.where(date: date, meal_type: meal_type)
    if existing_meal_plans.count >= 3
      # Delete the oldest meal plan of this meal type for this day
      oldest_meal_plan = existing_meal_plans.order(created_at: :asc).first
      oldest_meal_plan.destroy
    end

    # Create the new meal plan
    new_meal_plan = MealPlan.create(user: current_user, date: date, meal_type: meal_type, recipe_id: recipe_id)

    # Reload meal plans and render the week calendar
    @meal_plans = current_user.meal_plans
    @start_date = Date.parse(date)
    render_week_calendar
  end

  def destroy
    meal_plan_id = params[:id]
    meal_plan = MealPlan.find_by(id: meal_plan_id, user: current_user)

    if meal_plan
      meal_plan.destroy
      @meal_plans = current_user.meal_plans
      @start_date = meal_plan.date || Date.today
      render_week_calendar
    else
      render json: { error: 'Meal plan not found' }, status: :not_found
    end
  end

  private

  def render_week_calendar
    @calendar = instantiate_calendar(@start_date)
    respond_to do |format|
      format.html { render partial: "simple_calendar/week_calendar", locals: { calendar: @calendar, start_date: @start_date } }
    end
  end

  def instantiate_calendar(start_date)
    OpenStruct.new(
      start_date: start_date,
      url_for_previous_view: meal_planner_index_path(start_date: start_date - 1.week),
      url_for_today_view: meal_planner_index_path(start_date: Date.today),
      url_for_next_view: meal_planner_index_path(start_date: start_date + 1.week)
    )
  end

  def week_of_month_label(start_date)
    "#{start_date.strftime('%B %Y')}" if start_date
  end

  def date_range(start_date)
    (start_date.beginning_of_week..start_date.end_of_week).to_a
  end

  def recipe_options
    Recipe.where(user: current_user).pluck(:title, :id)
  end
end
