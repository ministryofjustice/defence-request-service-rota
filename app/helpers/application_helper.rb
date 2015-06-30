module ApplicationHelper

  # Devise will add extra flash messages.
  # We only want to display alerts, notices and errors
  def flash
    super.select {|key, _| key.to_s.in?(%w{alert notice error}) }
  end

  def flash_messages
    capture do
      flash.each do |key, msg|
        concat flash_message(key, msg)
      end
    end
  end

  def flash_message(key, msg)
    content_tag(:div, class: "#{key}-summary") do
      content_tag :p, msg
    end
  end

  def object_error_messages(object)
    active_model_messages = object.errors.messages

    content_tag(:ul) do
      active_model_messages.each do |field_name, field_messages|
        field_name_text = object.class.human_attribute_name field_name
        concat errors_for_field(field_name_text, field_messages)
      end
    end
  end

  def errors_for_field(field_name, field_messages)
    content_tag :li do
      "#{field_name}: #{field_messages.join(', ')}".html_safe
    end
  end
end
