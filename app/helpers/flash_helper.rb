module FlashHelper
  def flash_messages
    flash_messages = []
    flash.each do |key, value|
      flash_messages << content_tag(:div, value.html_safe, class: key)
    end
    flash_messages.join.html_safe
  end
end
