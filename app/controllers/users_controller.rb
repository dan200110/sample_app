class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t(".welcome_to")
      redirect_to @user
    else
      flash.now[:danger] = t(".danger")
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end
end
