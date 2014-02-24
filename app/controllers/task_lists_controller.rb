class TaskListsController < ApplicationController
  before_filter :require_login!

  def index
    @task_lists = TaskList.all.group_by(&:client)
  end

  def new
    @task_list = TaskList.new
  end

  def create
    @task_list = TaskList.new task_list_params
    if @task_list.save
      redirect_to task_lists_path
    else
      render :new
    end
  end

  def edit
    @task_list = TaskList.find(params[:id])
  end

  def update
    @task_list = TaskList.find(params[:id])
    if @task_list.update_attributes(task_list_params)
      redirect_to task_lists_path
    else
      render :edit
    end
  end

  def destroy
    @task_list = TaskList.find(params[:id])
    @task_list.destroy
    redirect_to task_lists_path
  end

  private

  def task_list_params
    params.require(:task_list).permit(:id, :client_id, :name, :tasks_attributes => [:id, :task_name, :_destroy])
  end
end
