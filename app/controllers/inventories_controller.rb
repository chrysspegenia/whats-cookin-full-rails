class InventoriesController < ApplicationController

  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    if @user.inventory
      redirect_to user_inventory_path(@user, @user.inventory), notice: 'Inventory already exists.'
    else
      @inventory = @user.build_inventory
    end
  end

  def create
    if @user.inventory
      redirect_to user_inventory_path(@user, @user.inventory), notice: 'Inventory already exists.'
    else
      @inventory = @user.build_inventory(inventory_params)
      if @inventory.save
        redirect_to user_inventory_path(@user, @inventory), notice: 'Inventory was successfully created.'
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to user_inventory_path(@user, @inventory), notice: 'Inventory was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to new_user_inventory_path(@user), notice: 'Inventory was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_inventory
    @inventory = @user.inventory
  end

  def inventory_params
    params.require(:inventory).permit(:user_id)
  end
end
