class IngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inventory
  before_action :set_ingredient, only: [:edit, :update, :destroy, :decrease, :increase]

  def create
    @ingredient = @inventory.ingredients.build(ingredient_params)
    @ingredient.user = current_user
    if @ingredient.save
      redirect_to myinventory_path, notice: 'Ingredient was successfully created.'
    else
      @userdetails = current_user
      render 'inventories/myinventory'
    end
  end

  def edit
    @ingredient = @inventory.ingredients.find(params[:id])
  end

  def update
    @ingredient = @inventory.ingredients.find(params[:id])
    if @ingredient.update(ingredient_params)
      redirect_to myinventory_path, notice: 'Ingredient was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ingredient = @inventory.ingredients.find(params[:id])
    @ingredient.destroy
    redirect_to myinventory_path, notice: 'Ingredient was successfully destroyed.'
  end

  def decrease
    @ingredient.quantity -= params[:amount].to_i
    if @ingredient.quantity <= 0
      @ingredient.destroy
      notice = 'Ingredient was successfully removed.'
    else
      @ingredient.save
      notice = 'Ingredient quantity was successfully decreased.'
    end
    redirect_to myinventory_path, notice: notice
  end

  def increase
    @ingredient.quantity += params[:amount].to_i
    @ingredient.save
    notice = 'Ingredient quantity was successfully increased.'
    redirect_to myinventory_path, notice: notice
  end

  private

  def set_inventory
    @inventory = current_user.inventory
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :quantity)
  end

  def set_ingredient
    @ingredient = @inventory.ingredients.find(params[:id])
  end
end