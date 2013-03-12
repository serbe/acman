class GroupsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @groups }
    end
  end

  def new
    @group = Group.new
    @title = 'Create new group'
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      redirect_to @group
    else
      @title = 'Create group'
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
    @users = User.order(sort_column + ' ' + sort_direction)
    @title = @group.name
  end

  def edit
    @group = Group.find(params[:id])
    @title = @group.name
  end

  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
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