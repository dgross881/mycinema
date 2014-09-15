module ApplicationHelper
  def rating_options(selected=nil) 
    options_for_select((1..5).map { |number| [pluralize(number, "Star"), number]}, selected) 
  end 
end
