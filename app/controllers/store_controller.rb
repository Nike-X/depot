class StoreController < ApplicationController
  require 'date'
  
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
    @date = DateTime.now
  end
end
