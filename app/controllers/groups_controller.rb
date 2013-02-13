class GroupsController < ApplicationController
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
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
end