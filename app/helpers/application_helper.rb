module ApplicationHelper

  def body_class
    "#{controller.controller_name} #{controller.action_name}"
  end

  def rails_context
    body_class.gsub(' ', '#')
  end
end
