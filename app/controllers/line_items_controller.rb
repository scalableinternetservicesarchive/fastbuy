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
    @line_item = Cart.add_product(@cart, params[:product_id], params[:quantity].to_i, params[:price].to_f)
    respond_to do |format|
      if @line_item.class == LineItem || @line_item.class == Product
        format.html { redirect_to store_url }
        format.js   { @current_item = @line_item }
        format.json { render action: 'show', status: :created, location: @line_item }
      elsif @line_item.nil?
        format.html { redirect_to store_url }
        format.js
        format.json { render :show, status: :ok}
      else
        if @line_item == 1
          format.html { redirect_to store_url }
          format.js
          format.json { render :show, status: :ok, location: @line_item }
        else 
          format.html { redirect_to store_url }
          format.js { @current_item = 2 }
        end
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    @line_item = Cart.add_product(@cart, params[:product_id], params[:quantity].to_i, params[:price].to_f)
    respond_to do |format|
      if @line_item.class == LineItem || @line_item.class == Product
        format.html { redirect_to store_url }
        format.js   { @current_item = @line_item }
        format.json { render action: 'show', status: :created, location: @line_item }
      elsif @line_item.nil?
        format.html { redirect_to store_url }
        format.js
        format.json { render :show, status: :ok}
      else
        if @line_item == 1
          format.html { redirect_to store_url }
          format.js
          format.json { render :show, status: :ok, location: @line_item }
        else 
          format.html { redirect_to store_url }
          format.js  { @current_item = 2 }
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
      format.html { redirect_to :back, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
    rescue ActionController::RedirectBackError
      redirect_to store_url
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
      params.require(:line_item).permit(:product_id, :quantity)
    end
end
