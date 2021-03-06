class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def new
  	@title = "Sign up"
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	
  	if @user.save
  		redirect_to user_path(@user), flash: { success: "Welcome #{@user.name}" }
  	else
  		@title = "Sign up"
  		render 'new'
  	end
  end
end
