class UsersController < ApplicationController
  ## Listing 10.9 By default, before filters apply to every action in
  ## a controller, so here we restrict the filter to act only on the
  ## :edit and :update actions by passing the :only options hash.
  before_filter :authenticate, :only => [:edit, :update]

  ## Listing 10.12 We add a second before filter to call the
  ## correct_user method
  before_filter :correct_user, :only => [:edit, :update]

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user # Listing 9.26
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      ## Reset password input after failed password attempt
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end
  end

  ## Listing 10.2
  def edit
    # @user = User.find(params[:id]) ## Listing 10.14
    @title = "Edit user"
  end

  ## Listing 10.7
  def update
    # @user = User.find(params[:id]) ## Listing 10.14
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  ## Listing 10.9
  private
  
  def authenticate
    deny_access unless signed_in?
  end

  ## Listing 10.12
  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
