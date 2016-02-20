module ApplicationHelper
  def nav_link_to(text, url, options = { })
    if current_page?(url)
      %{<li class="active">#{link_to(text, url, options)}</li>}.html_safe
    else
      %{<li>#{link_to(text, url, options)}</li>}.html_safe
    end
  end

  def format_date(date)
    if date.today?
      date.strftime("%l:%M %p")
    else
      date.strftime("%a %e %b")
    end
  end
end
