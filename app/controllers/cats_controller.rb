class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find_by_id(params[:id])
    @rental_requests = CatRentalRequest.requests_for_cat_id(@cat.id)
    if @cat
      render :show
    else
      redirect_to cats_url
    end
  end

  def new
    @cat = Cat.new(age: 0, birth_date: Time.now.to_date, color: "black", name: "", sex: 'm')
    render :form
  end

  def create
    @cat = Cat.new(params[:cat])
    if @cat.save
      redirect_to cat_url(@cat)
    else
      redirect_to cats_url('new')
    end
  end

  def edit
    @cat = Cat.find_by_id(params[:id])
    if @cat
      render :form
    else
      redirect_to cats_url
    end
  end

  def update
    @cat = Cat.find_by_id(params[:id])
    if @cat
      @cat.age = params[:cat][:age]
      @cat.birth_date = params[:cat][:birth_date]
      @cat.color = params[:cat][:color]
      @cat.name = params[:cat][:name]
      @cat.sex = params[:cat][:sex]
      if @cat.save
        redirect_to cat_url(@cat)
      else
        redirect_to edit_cat_url(@cat)
      end
    else
      redirect_to cats_url
    end
  end
end
