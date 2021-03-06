ActionController::Routing::Routes.draw do |map|

  # RESTFUL RESOURCES ===============================================
  ## PD 2010-05-10 Make User model RESTful
  #map.resources :users

  ## PD 2010-06-20
  ## 
  ## Listing 12.19 Adding following and followers actions to the Users
  ## controller.
  ##
  ## URLs for user following and followers will look like
  ## /users/1/following and /users/1/followers
  map.resources :users, :member => { :following => :get, :followers => :get }

  ## PD 2010-05-14 Make Session model RESTful
  map.resources :sessions, :only => [:new, :create, :destroy]

  ## Listing 11.21 Routes for the Microposts resource
  map.resources :microposts, :only => [:create, :destroy]

  ## Listing 12.24. Adding the routes for user relationships.
  map.resources  :relationships, :only => [:create, :destroy]


  # NESTED ROUTES ===================================================
  ## PD 2010-06-15
  ##
  ## Exercise 11.5.8 Add a nested route so that /users/1/microposts
  ## shows all the microposts for user 1. (You will also have to add a
  ## Microposts controller index action and corresponding view.)
  map.resources :users, :has_many => :microposts

  # NAMED ROUTES ====================================================
  map.signin  '/signin',  :controller => 'sessions', :action => 'new'
  map.signout '/signout', :controller => 'sessions', :action => 'destroy'

  ## PD 2010-05-08 Routes for static pages
  map.contact '/contact', :controller => 'pages', :action => 'contact'
  map.about   '/about',   :controller => 'pages', :action => 'about'
  map.help    '/help',    :controller => 'pages', :action => 'help'
  map.signup  '/signup',  :controller => 'users', :action => 'new'


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => 'pages', :action => 'home'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
