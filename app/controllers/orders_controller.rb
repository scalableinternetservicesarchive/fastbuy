class OrdersController < ApplicationController
  before_action do
    redirect_to store_path if !current_seller.nil?
  end
  before_action :authenticate_buyer!
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.where(buyer: current_buyer)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.buyer = current_buyer
    @order.add_line_items_from_cart(@cart)

    _has_succeeded = true
    @order.transaction do
      _has_succeeded = @order.save && update_product_count()
      # Before deleting the cart, we need to update the quantity of the products
      # related to the line items of this cart
      @cart.line_items.destroy
    end

    respond_to do |format|
      if _has_succeeded
        OrderNotifier.received(@order).deliver_later(wait: 2.second)
        OrderNotifier.shipped(@order).deliver_later(wait: 8.second)
        format.html { redirect_to store_url, notice: 
          'Thank you for your order.' }
        format.json { render action: 'show', status: :created,
          location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors,
          status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end

    def update_product_count
        @order.line_items.each do |item|
          if item.product.on_sale?
            salep = item.product.sale_products.first
            salep.quantity -= item.quantity
            if !salep.save
              return false
            end
          else
            item.product.quantity -= item.quantity
            if !item.product.save
              return false
            end
          end
        end
        return true
    end
end
