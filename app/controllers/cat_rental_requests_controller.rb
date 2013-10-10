class CatRentalRequestsController < ApplicationController
  def new
    @cats = Cat.all
    render :request_form
  end

  def create
    @rental_request = CatRentalRequest.new(params[:rental_request])
    if @rental_request.save
      redirect_to cat_url(Cat.find_by_id(@rental_request.cat_id))
    else
      redirect_to new_cat_rental_request_url
    end
  end

  def approve
    rental_request = CatRentalRequest.find(params[:id])
    rental_request.approve!
    redirect_to cat_url(Cat.find_by_id(rental_request.cat_id))
  end

  def deny
    rental_request = CatRentalRequest.find(params[:id])
    rental_request.deny!
    redirect_to cat_url(Cat.find_by_id(rental_request.cat_id))
  end
end
