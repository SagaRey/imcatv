class CommentsController < ApplicationController
  before_action :is_admin, only: [:destroy]

  def create
    @news = News.find(params[:news_id])
    @comment = @news.comments.create(comment_params)
    redirect_to news_path(@news)
  end

  def destroy
    @news = News.find(params[:news_id])
    @comment = @news.comments.find(params[:id])
    @comment.destroy
    redirect_to news_path(@news)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end

    def is_admin
      redirect_to root_url unless admin_logged?
    end
end