class LineItemsController < ApplicationController
  include CurrentCart
  before_action do
    redirect_to store_path if !current_seller.nil?
  end
  before_action :set_cart
  before_action :set_line_item, only: [:destroy]

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = Cart.add_product(@cart, line_item_params)
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

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    if @line_item == nil
      @cart.delete(line_item_params[:product_id])
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
      if @cart.class == Cart
        @line_item = LineItem.find(params[:id])
      end
    end

   # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :quantity)
    end
end
