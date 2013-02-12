class GroupsController < ApplicationController
  def new
    @group = Group.new
    @title = 'Create new group'
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      redirect_to @group
    else
      @title = 'Create user'
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
    @title = @group.name
  end
end