class StoreController < ApplicationController
  skip_before_action :authorize
  require 'date'
  
  include CurrentCart
  before_action :set_cart
  def index
    @date = DateTime.now
    if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
  end
end
