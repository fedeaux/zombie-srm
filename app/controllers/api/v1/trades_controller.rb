class Api::V1::TradesController < Api::V1::ApiController
  def create
    status = Services::Trades::Perform.new.perform trade_params['trade']

    if status[:status] == 'error'
      render json: status, status: :bad_request
    else
      render json: status, status: :ok
    end
  end

  private

  def trade_params
    params.permit(trade: [:survivor_id, :water, :food, :medication, :ammunition])
  end
end
