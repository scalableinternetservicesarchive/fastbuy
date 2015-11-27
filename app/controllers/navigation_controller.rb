class NavigationController < ApplicationController
  def contact
    expires_in 24.hours, public: true
  end
end
