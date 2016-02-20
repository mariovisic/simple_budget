class NavPresenter < ApplicationPresenter
  include ActionView::Helpers::UrlHelper

  def nav_link_to(*args)
    link_to(args)
  end
end
