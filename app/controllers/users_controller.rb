class UsersController < ApplicationController
  ## Listing 10.9 By default, before filters apply to every action in
  ## a controller, so here we restrict the filter to act only on the
  ## :edit and :update actions by passing the :only options hash.
  # before_filter :authenticate, :only => [:edit, :update]

  ## Listing 10.19
  # before_filter :authenticate, :only => [:index, :edit, :update]

  ## Listing 10.39 (A before filter restricting the destroy action to admins.)
  # before_filter :authenticate, :only => [:index, :edit, :update, :destroy]

  ## Listing 12.29. The following and followers actions.
  before_filter :authenticate, :except => [:show, :new, :create]

  ## Listing 10.12 We add a second before filter to call the
  ## correct_user method
  before_filter :correct_user, :only => [:edit, :update]

  ## Listing 10.39 (A before filter restricting the destroy action to admins.)
  before_filter :admin_user,   :only => :destroy

  ## Exercise 10.6.3 Signed-in users have no reason to access the new
  ## and create actions in the Users controller. Arrange for such
  ## users to be redirected to the root url if they do try to hit
  ## those pages.
  before_filter :signed_in_user, :only => [:new, :create]

   ## Listing 10.19
  def index
    @title = "All users"
    # @users = User.all ## old
    @users = User.paginate(:page => params[:page]) ## Listing 10.27
  end

  def show
    @user = User.find(params[:id])
    ## Listing 11.18 Adding an @microposts instance variable to the user show action. 
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = CGI.escapeHTML(@user.name)
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
    @title = "Edit user" ## Listing 10.14
  end

  ## Listing 10.7
  def update
    # @user = User.find(params[:id]) ## Listing 10.14
    if @user.update_attributes(params[:user])  ## Listing 10.14
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  ## Listing 10.39
  def destroy
    ## Exercise 10.6.5 Modify the destroy action to prevent admin
    ## users from destroying themselves.
    user =  User.find(params[:id])
    if current_user?(user)
      flash[:error] = "Admin suicide warning: Can't delete yourself."
    else
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end

  ## Listing 12.29. The following and followers actions.
  def following
    # @title = "Following"
    # @user = User.find(params[:id])
    # @users = @user.following.paginate(:page => params[:page])
    # render 'show_follow'
    ## Exercise 12.5.2 The following and followers actions in Listing
    ## 12.29 still have considerable duplication. Verify that the
    ## show_follow method in Listing 12.47 eliminates this
    ## duplication.
    show_follow(:following)
  end

  def followers
    # @title = "Followers"
    # @user = User.find(params[:id])
    # @users = @user.followers.paginate(:page => params[:page])
    # render 'show_follow'
    ## Exercise 12.5.2 The following and followers actions in Listing
    ## 12.29 still have considerable duplication. Verify that the
    ## show_follow method in Listing 12.47 eliminates this
    ## duplication.
    show_follow(:followers)
  end

  ## Exercise 12.5.2 The following and followers actions in Listing
  ## 12.29 still have considerable duplication. Verify that the
  ## show_follow method in Listing 12.47 eliminates this duplication.
  ##
  ## Listing 12.47. Refactored following and followers actions.
  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render 'show_follow'
  end
  
  # =================================================================
  # PRIVATE =========================================================
  # =================================================================
  private

  ## Moved to app/helpers/sessions_helper.rb!
  # ## Listing 10.9
  # def authenticate
  #   deny_access unless signed_in?
  # end

  ## Listing 10.12
  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
  end

  ## Listing 10.39
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  ## Exercise 10.6.3 Signed-in users have no reason to access the new
  ## and create actions in the Users controller. Arrange for such
  ## users to be redirected to the root url if they do try to hit
  ## those pages.
  def signed_in_user
    if current_user?(@user)
      flash[:success] = "You are already signed in"
    else
      redirect_to root_path# unless current_user?(@user)
    end
  end
end
