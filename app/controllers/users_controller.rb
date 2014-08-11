class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  # Checks signin status (see below) prior to 'edit' and 'update' actions
  # Redirects to signin_path unless signed in.
  before_action :signed_in_cant_signup, only: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
    @users = User.paginate(page: params[:page])
  end

  def show # GET      /users/1     user_path(user)      page to show user
  	@user = User.find(params[:id])
  end

  def new # GET       /users/new   new_user_path        make new user page (signup)      
  	@user = User.new
  end

  def create # POST   /users       users_path           create a new user
  	@user = User.new(user_params) # Not the final implementation
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit #GET     /users/1/edit   edit_user_path(user)    page to edit user
    # @user = User.find(params[:id]) <-- Folded into 'correct_user' method; see below
  end

  def update #PATCH   /users/1      user_path(user)         update user
    # @user = User.find(params[:id]) <-- Folded into 'correct_user' method; see below
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user 
    else
      render 'edit'
    end
  end

  def destroy
    user_to_delete = User.find(params[:id])
    if current_user?(user_to_delete)
      redirect_to root_url
    else
      user_to_delete.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end

  private

    def user_params
    	params.require(:user).permit(:name, :email,
    		                            :password, :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
        # REPLACED: redirect_to signin_url, notice: "Please sign in." unless signed_in?
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      unless current_user.admin?
        redirect_to (root_url) 
      end
    end

    def signed_in_cant_signup
      if signed_in?
        redirect_to root_url
      end
    end
=begin

  Above single line is less verbose, but equivalent to:

        unless signed_in?
          flash[:notice] = "Please sign in."
          redirect_to signin_url
        end

  However, same construction does NOT work for :error or :success keys.
=end

end
