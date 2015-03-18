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
end
