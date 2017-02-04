require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  
  test 'buying a product' do
    # Clear all orders and items list
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
  
    # Getting store page
    get "/"
    assert_response :success
    assert_template :index
  
   # Add item to cart
    xml_http_request :post, "/line_items", product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # Create order
    get "/orders/new"
    assert_response :success
    assert_template :new

    # Add order`s data and check redirection to the main page
    post_via_redirect "/orders",
  order: {name: "Dave Thomas",
          address: "123 The Street",
          email: "dave@example.com",
          pay_type: "Check"}
    assert_response :success
    assert_template :index
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # Check orders in database
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    # Check mail notification
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Nick-X <depot@example.com>', mail[:from].value
    assert_equal 'Подтверждение заказа в Pragmatic Store', mail.subject
  end
  
end
