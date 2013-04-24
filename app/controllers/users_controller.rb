class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def destroy
    if User.find(params[:id]).admin?
      flash[:notice] = "Cannot delete admin"
      redirect_to users_path
    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end

  def show
  	@user = User.find(params[:id])
  end
  
  def new
  	if signed_in?
      redirect_to(root_path)
    else
      @user = User.new
    end
  end

  def create
  	redirect_to(root_path) unless !signed_in?
    @user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
   
    # Code for testing the request command
    test_request = nil
    if test_request
      if request.local? 
        flash[:notice] = "Local request from " << request.ip << " located at " << request.fullpath
      else
        flash[:notice] = "Nonlocal request"
      end
    end
  
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
