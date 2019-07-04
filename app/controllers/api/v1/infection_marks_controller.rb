class Api::V1::InfectionMarksController < Api::V1::ApiController
  def create
    @infection_mark = InfectionMark.new infection_mark_params

    if @infection_mark.save
      render 'show', status: :created
    else
      render 'show', status: :unprocessable_entity
    end
  end

  private

  def infection_mark_params
    params.require(:infection_mark).permit(:from_id, :to_id)
  end
end
