module ApplicationHelper

  def admin_logged?
    if !session[:admin].nil? && session[:admin] == "admin"
      true
    else
      false
    end
  end

  def is_admin?(password)
    password == "passwd" ? true : false
  end

  def admin_login
    session[:admin] = "admin"
  end

  def admin_logout
    session[:admin] = nil
  end

  def full_title(page_title = '')
    base_title = "ImbaTV"
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def active_li(page_title = '', title = 'Imbatv')
    if page_title == title
      'class=active'
    else
      ''
    end
  end
end
