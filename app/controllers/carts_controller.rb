class CartsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  
  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    puts '@@-Current Cart ' + @cart.id.to_s  + ' to show ' + params[:id].to_s + '-@@'
    if @cart.id.to_i != params[:id].to_i
      invalid_cart
      puts "@@-Cart not match-@@"
    end
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to store_url  }
      format.json { head :no_content }
    end
  end

  private
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params[:cart]
    end
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, notice: 'Invalid cart'
    end

end
