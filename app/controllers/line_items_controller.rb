class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    puts "INDEX"
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    puts "CREATE"
    puts params[:quantity]
    product = Product.find(params[:product_id])

    @line_item = @cart.add_product(product.id, params[:quantity].to_i)

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

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    
    @line_item.quantity += params[:delta].to_i

    respond_to do |format|
      if @line_item.quantity > 0 && @line_item.save
	format.html { redirect_to store_url, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      elsif @line_item.quantity > @line_item.product.quantity
        format.html { redirect_to store_url, notice: 'No more items available for this product.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        @line_item.destroy
        format.html { redirect_to store_url, notice: 'Line item was deleted.' }
        format.json { render :show, status: :ok, location: @line_item }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
#      if @line_item != nil && @line_item.cart != nil
        format.html { redirect_to store_url, notice: 'Line item was successfully destroyed.' }
#      else
#        format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
#      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

   # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end

end

