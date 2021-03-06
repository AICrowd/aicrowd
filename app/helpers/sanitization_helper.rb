module SanitizationHelper
  def sanitize_html(html_content)
    Sanitize.fragment(html_content, Sanitize::Config::RELAXED).html_safe
  end

  def sanitize_html_with_attr(html_content, elements: [], attributes: {})
    Sanitize.fragment(html_content, Sanitize::Config.merge(Sanitize::Config::RELAXED, elements: Sanitize::Config::BASIC[:elements] + elements, attributes: attributes)).html_safe
  end
end
