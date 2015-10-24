class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:show, :edit, :create, :update, :destroy]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    if @cart.class == Hash
      respond_to do |format|
        format.html { redirect_to store_url, notice: 'Sorry, item in temp cart currently is not visable.' }
      end
    end
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
    if @cart.class == Hash
      respond_to do |format|
        format.html { redirect_to store_url, notice: 'Sorry, item in temp cart currently is not editable.' }
       end
    end
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    if @cart.class == Hash
      if @cart[product.id.to_s]
        @cart[product.id.to_s] = @cart[product.id.to_s].to_i + params[:quantity].to_i
      else 
        @cart[product.id.to_s] = 1
      end
      respond_to do |format|
        format.html { redirect_to store_url }
        format.js   { @current_item = @product }
        format.json { render action: 'show', status: :created }
      end
   else
      @line_item = @cart.add_product(params[:product_id], params[:quantity].to_i)
      respond_to do |format|
        if @line_item.save
          format.html { redirect_to store_url }
          format.js   { @current_item = @line_item }
          format.json { render action: 'show', status: :created, location: @line_item }
        else
          format.html { render action: 'new' }
          format.json { render json: @line_item.errors, status: :unprocessable_entity }
        end
      end
   end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    if @cart.class == Hash
      product = Product.find(params[:product_id])
      new_quantity =  @cart[product.id.to_s].to_i + params[:quantity].to_i
      respond_to do |format|
        if  new_quantity > 0 && new_quantity <=  product.quantity
          @cart[product.id.to_s] = @cart[product.id.to_s].to_i + params[:quantity].to_i
          format.html { redirect_to store_url, notice: 'Line item was successfully updated.' }
          format.js   { @current_item = @product }
          format.json { render :show, status: :ok}
        elsif new_quantity > product.quantity
          format.html { redirect_to store_url, notice: 'No more items available for this product.' }
          format.json { render :show, status: :ok}
        else
          @cart.delete(params[:product_id])
          format.js   { @current_item = @product }
          format.html { redirect_to store_url, notice: 'Line item was deleted.' }
          format.json { render :show, status: :ok}
        end
      end
    else
      @line_item.quantity += params[:quantity].to_i
      respond_to do |format|
        # Need fixes Here, save first???
        if @line_item.quantity > 0 && @line_item.save
          format.html { redirect_to store_url, notice: 'Line item was successfully updated.' }
          format.js
          format.json { render :show, status: :ok, location: @line_item }
        elsif @line_item.quantity > @line_item.product.quantity
          format.html { redirect_to store_url, notice: 'No more items available for this product.' }
          format.json { render :show, status: :ok, location: @line_item }
        else
          @line_item.destroy
          format.html { redirect_to store_url, notice: 'Line item was deleted.' }
          format.js
          format.json { render :show, status: :ok, location: @line_item }
        end
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    if @line_item == nil
      @cart.delete(params[:product_id])
    else  
      @line_item.destroy
    end
    respond_to do |format|
      format.html { redirect_to store_url, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      if @cart.class == Hash
        @line_item = nil
      else 
        @line_item = LineItem.find(params[:id])
      end
    end

   # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
     # Need Fixes Here what is this used for?
      params.require(:line_item).permit(:product_id, :quantity)
    end
end
