class NavigationController < ApplicationController
  def contact
    expires_in 2.hours, public: true
  end
end
