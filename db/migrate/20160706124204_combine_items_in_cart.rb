class CombineItemsInCart < ActiveRecord::Migration
  def up
	# replace few records for same product by one
	Cart.all.each do |cart|
		# count quantity for each product in cart
		sums = cart.line_items.group(:product_id).sum(:quantity)
		
		sums.each do |product_id, quantity|
			if quantity > 1
				# del separate records
				cart.line_items.where(product_id: product_id).delete_all
				
				# replace by one record
				item = cart.line_items.build(product_id: product_id)
				item.quantity = quantity
				item.save!
			end
		end
	end
  end
  
  def down
	# split records with quantity>1 into few records
	LineItem.where("quantity>1").each do |line_item|
		#add individual items
		line_item.quantity.times do
			LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
		end
		
		# delete original record
		line_item.destroy
	end
  end
end
