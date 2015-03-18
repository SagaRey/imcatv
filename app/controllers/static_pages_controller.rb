class StaticPagesController < ApplicationController

  def home
    @news = News.order(created_at: :desc).take(8)
  end

  def login
    if is_admin?(params[:admin][:password])
      admin_login
      redirect_to request.referrer
    else
      redirect_to root_url
    end
  end

  def logout
      admin_logout
      redirect_to request.referrer
  end
end
