class AddrsController < ApplicationController
  def index
    @banlist = Banlist.find(params[:banlist_id])
    @addrs = @banlist.addrs.all.paginate(:page => params[:page])
  end

  def edit
    @banlist = Banlist.find(params[:id])
    #@addr = @banlist.addrs.find(params[:id])
  end
end
