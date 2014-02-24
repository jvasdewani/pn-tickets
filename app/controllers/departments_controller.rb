class DepartmentsController < ApplicationController
  before_filter :require_login!

  def index
    @departments = Department.ordered
  end

  def new
    @department = Department.new
    @department.build_task_list
    @department.task_list.tasks.build
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to departments_path
    else
      render :action => :new
    end
  end

  def edit
    @department = Department.find(params[:id])
    if @department.task_list.nil?
      @department.build_task_list
      @department.task_list.tasks.build
    end
  end

  def update
    @department = Department.find(params[:id])
    if @department.update_attributes(department_params)
      redirect_to departments_path
    else
      render :action => :edit
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    # Need to process assigned tickets
    redirect_to departments_path
  end

  def show
    @department = Department.find(params[:id])
  end

  private

  def department_params
    params.require(:department).permit(:id, :department_name, :notify_on_close, :notify_list, :task_list_attributes => [ :id, :tasks_attributes => [:id, :task_name, :_destroy]])
  end
end
