class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :find_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def show
    @pagy, @microposts = pagy @user.microposts
  end

  def new
    @user = User.new
  end

  def index
    @pagy, @users = pagy User.latest_user
  end

  def update
    if @user.update user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t ".update_fail"
      render :edit
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def edit; end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".destroy_fail"
    end
    redirect_to users_path
  end

  def following
    @title = t ".following"
    @pagy, @users = pagy @user.following
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @pagy, @users = pagy @user.followers
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("users.before_action.not_correct")
    redirect_to root_path
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t("users.before_action.not_admin")
    redirect_to root_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("users.before_action.not_found")
    redirect_to root_path
  end
end
