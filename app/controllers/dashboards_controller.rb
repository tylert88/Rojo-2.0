class DashboardsController < ApplicationController
before_action :authenticate_user!

def index
  @parkings = current_user.parkings
  end
end
