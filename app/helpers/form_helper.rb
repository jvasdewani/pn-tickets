module FormHelper
  def error_message_on(object, method, *args)
    options = args.extract_options!
    unless args.empty?
      options[:prepend_text] = args[0] || ''
      options[:append_text] = args[1] || ''
      options[:css_class] = args[2] || 'formError'
    end
    options.reverse_merge!(:prepend_text => '', :append_text => '', :css_class => 'formError')

    obj = (object.respond_to?(:errors) ? object : object.object)
    if !obj.errors.empty? && obj.errors.has_key?(method)
      content_tag("div","#{options[:prepend_text]}#{method.to_s.humanize} #{obj.errors[method].first}#{options[:append_text]}".html_safe, :class => options[:css_class])
    else
      ''
    end
  end
end
