class SaleProductsController < ApplicationController
  before_action :authenticate_seller!
  before_action :set_sale_product, except: [:index, :new, :create]
  before_action :seller_verification, except: [:index, :new, :create]

  # GET /sale_products
  # GET /sale_products.json
  def index
    @sale_products = SaleProduct.where(seller: current_seller)
  end

  # GET /sale_products/1
  # GET /sale_products/1.json
  def show
  end

  # GET /sale_products/new
  def new
    if params[:sale_product]
      product = Product.find(sale_product_params[:product_id])
      if current_seller != product.seller
        redirect_to sale_products_path, notice: "You are not the owner of the sale product."
      else
        @sale_product = SaleProduct.new(sale_product_params)
        @sale_product.seller = product.seller
      end
    else
      @sale_product = SaleProduct.new({seller: current_seller})
    end
  end

  # GET /sale_products/1/edit
  def edit
  end

  # POST /sale_products
  # POST /sale_products.json
  def create
    if product = Product.find_by_id(sale_product_params[:product_id])
      if current_seller != product.seller
        redirect_to sale_products_path, notice: "You are not the owner of the product."
      else

        @sale_product = SaleProduct.new(sale_product_params)
        _has_succeeded = true
        @sale_product.transaction do
          @sale_product.seller = product.seller
          @sale_product.product.on_sale = true
          _has_succeeded = @sale_product.save && @sale_product.product.save
        end  

        respond_to do |format|
          if _has_succeeded
            format.html { redirect_to @sale_product, notice: 'Sale product was successfully created.' }
            format.json { render :show, status: :created, location: @sale_product }
          else
            format.html { render :new, notice: 'Sale product is invalid!' }
            format.json { render json: @sale_product.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      respond_to do |format|
        format.html { render :new, notice: 'Product does not exist!' }
        format.json { render json: @sale_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_products/1
  # PATCH/PUT /sale_products/1.json
  def update
    respond_to do |format|
      if @sale_product.update(sale_product_params)
        format.html { redirect_to @sale_product, notice: 'Sale product was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale_product }
      else
        format.html { render :edit }
        format.json { render json: @sale_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_products/1
  # DELETE /sale_products/1.json
  def destroy
    @sale_product.destroy
    respond_to do |format|
      format.html { redirect_to sale_products_url, notice: 'Sale product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_product
      @sale_product = SaleProduct.find(params[:id])
    end

    def seller_verification
      if current_seller != @sale_product.seller
        redirect_to sale_products_path, notice: "You are not the owner of the sale product."
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_product_params
      params.require(:sale_product).permit(:product_id, :price, :quantity, :started_at, :expired_at)
    end
end
