class Api::V1::ReportsController < Api::V1::ApiController
  def index
    render json: Services::Reports::Main.new.perform
  end
end
