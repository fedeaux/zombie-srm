class Api::V1::ExercisesController < Api::V1::ApiController
  before_action :set_exercise, only: [:show, :update]

  def index
    @exercises = current_user.exercises
  end

  def show
  end

  def update
    if @exercise.update(exercise_params)
      render 'show', status: :ok
    else
      render 'show', status: :unprocessable_entuty
    end
  end

  def create
    @exercise = current_user.exercises.new exercise_params
    if @exercise.save
      render 'show', status: :created
    else
      render 'show', status: :unprocessable_entuty
    end
  end

  private

  def set_exercise
    @exercise = current_user.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:id, :name, :slug, :user_id, :group_id)
  end
end
