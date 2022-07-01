class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent"
      redirect_to root_path
    else
      flash.now[:danger] = t ".email_address"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".not_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t ".password_reset"
      redirect_to @user
    else
      flash[:danger] = t ".update fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t("users.before_action.not_found")
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_exprired"
    redirect_to new_password_reset_url
  end
end
