class InventoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  layout "dashboard_layout"

  def myinventory
    @inventory = current_user.inventory
    @userdetails = current_user
    @ingredient = @inventory.ingredients.build
  end

  def index
    @inventory = current_user.inventory
    @userdetails = current_user
  end

  def show
  end

  def new
    if current_user.inventory
      redirect_to user_inventory_path(current_user, current_user.inventory), notice: 'Inventory already exists.'
    else
      @inventory = current_user.build_inventory
    end
  end

  def create
    if current_user.inventory
      redirect_to user_inventory_path(current_user, current_user.inventory), notice: 'Inventory already exists.'
    else
      @inventory = current_user.build_inventory(inventory_params)
      if @inventory.save
        redirect_to user_inventory_path(current_user, @inventory), notice: 'Inventory was successfully created.'
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to user_inventory_path(current_user, @inventory), notice: 'Inventory was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to new_user_inventory_path(current_user), notice: 'Inventory was successfully destroyed.'
  end

  private

  def set_inventory
    @inventory = current_user.inventory
  end

  def inventory_params
    params.require(:inventory).permit(:user_id)
  end
end