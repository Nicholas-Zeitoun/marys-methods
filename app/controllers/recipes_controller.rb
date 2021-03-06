class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_recipe, only: [:destroy, :show, :edit, :update]

  def index
    if params[:query].present?
      sql_query = "name ILIKE :query"
      @recipes = Recipe.where(sql_query, query: "%#{params[:query]}%")
    else
      @recipes =Recipe.all
    end
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      redirect_to recipe_path(@recipe)
      # redirect_to recipe_path(@recipe)
    else
      render :new
    end
  end

  def edit
    @ingredient = Ingredient.new
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to root_path
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :duration, :category_id, :photo)
  end
end
