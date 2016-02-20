module ApplicationHelper
  def nav_link_to(text, url, options = { })
    if current_page?(url)
      %{<li class="active">#{link_to(text, url, options)}</li>}.html_safe
    else
      %{<li>#{link_to(text, url, options)}</li>}.html_safe
    end
  end
end
