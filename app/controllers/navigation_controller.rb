class NavigationController < ApplicationController
  def store
    redirect_to store_path
  end

  def sales
    if seller_signed_in?    
      redirect_to sale_products_path
    else 
      redirect_to store_path(search: "on_sale")
    end
  end

  def cart
  end

  def buyer
  end

  def seller
    if seller_signed_in?
      redirect_to products_path
    else
      redirect_to new_seller_session_path
    end
  end

  def contact
  end
end
