class NavigationController < ApplicationController
  def store
    redirect_to store_path
  end

  def sales
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
