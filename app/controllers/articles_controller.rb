class ArticlesController < ApplicationController

  before_action :set_article, only: [:edit,:update,:show,:destroy]
  before_action :require_user, excep: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destory]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end


  def edit
  end


  def create
   @article = Article.new(article_params)
    @article.user= current_user
    if @article.save
      flash[:success] = "Article was created"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end



  def update
    if @article.update(article_params)
      flash[:sucess] = "Article was updated"
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end



  def show
  end

  #Method to delete Articles

  def destroy
    @article.destroy
    flash[:danger] = "Article was deleted"
    redirect_to articles_path
  end


  private
  def article_params
    # The square backets mean the categorys are coming in as array formm.
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  # Creating a method for this as it repeats a lot

  def set_article
        @article = Article.find(params[:id])
  end

  def require_same_user
    if current_user != @article.user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own articles"
      redirect_to root_path
    end
  end

  end
