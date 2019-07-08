class Api::V1::SurvivorsController < Api::V1::ApiController
  before_action :set_survivor, only: [:show, :update]

  def index
    @survivors = Survivor.first(10)
  end

  def update
    if @survivor.update(survivor_update_params)
      render 'show', status: :ok
    else
      render 'show', status: :unprocessable_entity
    end
  end

  def create
    @survivor = Survivor.new survivor_params
    if @survivor.save
      render 'show', status: :created
    else
      render 'show', status: :unprocessable_entity
    end
  end

  private

  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :latitude, :longitude, :water, :food, :medication, :ammunition)
  end

  def survivor_update_params
    params.require(:survivor).permit(:latitude, :longitude)
  end
end
