class StaticPagesController < ApplicationController

  def home
    @news = News.order(created_at: :desc).take(8)
    @programs = Program.order(created_at: :desc).take(8)
    @notify = News.where("notify == ?", true).order(created_at: :desc).first
  end

  def login
    if is_admin?(params[:admin][:password])
      admin_login
      redirect_to request.referrer
    else
      redirect_to request.referrer
    end
  end

  def logout
      admin_logout
      redirect_to request.referrer
  end

  def ileague
  end
end
