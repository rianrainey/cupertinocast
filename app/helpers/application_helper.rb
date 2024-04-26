module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice then "alert alert-info" # Bootstrap class for informational messages
    when :success then "alert alert-success" # Bootstrap class for success messages
    when :error then "alert alert-danger" # Bootstrap class for error messages
    when :alert then "alert alert-warning" # Bootstrap class for warning messages
    else "alert alert-#{type}" # A generic class for any other type of message
    end
  end
end
