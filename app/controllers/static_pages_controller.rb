class StaticPagesController < ApplicationController

  def home
  end

  def login
    if is_admin?(params[:admin][:password])
      admin_login
      redirect_to manage_url
    else
      redirect_to root_url
    end
  end

  def manage
    redirect_to root_url unless admin_logged?
    admin_logout
  end
end
