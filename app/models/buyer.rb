class Buyer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :cart
  has_many :orders
end

def send_reset_password_instructions(reset_password_instructions, *args)
  devise_mailer.send(reset_password_instructions, *args).deliver_later(wait: 2.second)
end

