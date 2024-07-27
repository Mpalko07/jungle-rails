class CartsController < ApplicationController

  def show
  end

  def add_item
    product_id = params[:product_id].to_s
    product = Product.find_by(id: product_id)

    if product&.quantity.to_i > 0
      modify_cart_delta(product_id, +1)
      flash[:notice] = 'Product added to cart.'
    else
      flash[:alert] = 'Product is sold out.'
    end

    redirect_back fallback_location: root_path
  end

  def remove_item
    product_id = params[:product_id].to_s
    modify_cart_delta(product_id, -1)

    flash[:notice] = 'Product removed from cart.'
    redirect_back fallback_location: root_path
  end

  private

  def modify_cart_delta(product_id, delta)
    cart[product_id] = (cart[product_id] || 0) + delta
    cart.delete(product_id) if cart[product_id] < 1
    update_cart cart
  end

end
