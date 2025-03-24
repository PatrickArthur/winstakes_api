class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    products = Product.where(creator_id: current_user.id)
    render json: products
  end

  def create
    product = Product.new(product_params)
    product.creator_id = current_user.id 
    if product.save
      render json: product, status: :created
    else
      render json: {errords: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end