class UsersController < ApplicationController


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

  private

  def user_params
  	params.require(:user).permit(:name, :email,
  		:password, :password_confirmation)
  end
end
