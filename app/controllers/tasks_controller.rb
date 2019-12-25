class TasksController < ApplicationController
 helper_method :sort_column, :sort_direction
  def index
    @status = {1=> 'К выполнению', 2=> 'Выполняется', 3=> 'Выполнена', 4=> 'Отменен'}
    @priority = {1=> 'Низкий', 2=> 'Средний', 3=> 'Высокий'}

    if user_signed_in?
      @tasks = Task.order(sort_column + " " + sort_direction)
      @tasks = @tasks.where(responsible: current_user[:id])
      if !@tasks.include?(Task.where(creator: current_user[:id]))
        @tasks = @tasks + Task.where(creator: current_user[:id])
      end
      @tasks.uniq!
      @users = User.all

      # if params[:]
    end
  end

  def show
    @status = {1=> 'К выполнению', 2=> 'Выполняется', 3=> 'Выполнен', 4=> 'Отменен'}
    @priority = {1=> 'Низкий', 2=> 'Средний', 3=> 'Высокий'}

    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @user = User.where(supervisor_id: current_user[:id]) + User.where(id: current_user[:id])
    names = @user.pluck(:firstname)
    lastnames = @user.pluck(:lastname)
    @options = []
    names.each_with_index do |us, index|
      @options.push(["#{us} #{lastnames[index]}", @user[index].id])
    end
  end

  def edit
    @status = {1=> 'К выполнению', 2=> 'Выполняется', 3=> 'Выполнен', 4=> 'Отменен'}
    @task = Task.find(params[:id])
    @user = User.where(supervisor_id: current_user[:id]) + User.where(id: current_user[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(status: params[:status])
      redirect_to root_path
    else
      render :edit
    end
  end

  def create
    @task = Task.new(post_params)
    @task.status = 1
    @task.creator = current_user[:id]
    if user_signed_in?
      if @task.save
        redirect_to root_path
      else
        render :new
      end
    end
  end

  private

  def post_params
    params.permit(:title, :description, :date_fin, :priority, :status, :creator, :responsible)
  end

  def sort_column
   Task.column_names.include?(params[:sort]) ? params[:sort] : "title"
 end

 def sort_direction
   %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
 end

end
