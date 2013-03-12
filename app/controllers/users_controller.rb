class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @users = User.order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new
    @title = 'Create new user'
    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = @user.name
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end


  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user
    else
      @title = 'Create user'
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

end
