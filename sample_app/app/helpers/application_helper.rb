# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logo
    logo = image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
end
