class StoreController < ApplicationController
  skip_before_action :authorize
  require 'date'
  
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
    @date = DateTime.now
  end
end
