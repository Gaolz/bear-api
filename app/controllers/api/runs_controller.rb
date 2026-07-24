module Api
  class RunsController < ApplicationController
    before_action :authenticate!
    before_action :set_run, only: [:update, :destroy]

    def index
      runs = current_user.runs.order(date: :desc)
      render json: { runs: runs.map { |r| run_json(r) } }, status: :ok
    end

    def create
      run = current_user.runs.build(run_params)

      if run.save
        render json: { run: run_json(run) }, status: :created
      else
        render json: { errors: run.errors.full_messages }, status: :unprocessable_content
      end
    end

    def update
      if @run.update(run_params)
        render json: { run: run_json(@run) }, status: :ok
      else
        render json: { errors: @run.errors.full_messages }, status: :unprocessable_content
      end
    end

    def destroy
      @run.destroy
      head :no_content
    end

    private

    def set_run
      @run = current_user.runs.find(params[:id])
    end

    def run_params
      params.require(:run).permit(:date, :distance, :done)
    end

    def run_json(run)
      {
        id: run.id,
        date: run.date,
        distance: run.distance,
        done: run.done
      }
    end
  end
end
