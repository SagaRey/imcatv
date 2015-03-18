class StaticPagesController < ApplicationController

  def home
    @news = News.order(created_at: :desc).take(8)
  end

  def login
    if is_admin?(params[:admin][:password])
      admin_login
      redirect_to manage_url
    else
      admin_logout
      redirect_to root_url
    end
  end

  def manage
    redirect_to root_url unless admin_logged?
  end
end
