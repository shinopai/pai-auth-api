class Api::V1::TasksController < ApplicationController
  def index
    tasks = Task.all.order(created_at: :desc).joins(:user).select('tasks.*, users.name, users.id as user_id')

    render json: tasks
  end

  def create
    user = User.find(params[:user_id])
    task = user.tasks.new(task_params)

    if task.save
      render json: task, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.delete
  end

  def search
    res = Task.arel_table
    tasks = Task.where(res[:title].matches("%"+params[:search]+"%"))

    render json: tasks
  end

  private
  def task_params
    params.require(:task).permit(:title)
  end
end
