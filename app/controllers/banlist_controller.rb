class BanlistController < ApplicationController
  require 'will_paginate/array'

  def getbanlists
    banlists_path = 'd:\acman\usr\local\rejik3\banlists'
    Dir.foreach(banlists_path) do |fname|
      if fname != '.'
        if fname != '..'
          unless Banlist.find_by_name(fname)
            Banlist.create(:name => fname)
          end
          banlist = Banlist.find_by_name(fname)
          urls_path = banlists_path + '\\' + fname + '\\urls'
          if File.exist?(urls_path)
            File.new(urls_path).each_line do |line|
              unless line == '\n'
                unless banlist.addrs.find_by_name(line)
                  banlist.addrs.create(:name => line)
                end
              end
            end
          end
          pcre_path = banlists_path + '\\' + fname + '\\pcre'
          if File.exist?(pcre_path)
            File.new(pcre_path).each_line do |line|
              unless line == '\n'
                unless banlist.pcres.find_by_name(line)
                  banlist.pcres.create(:name => line)
                end
              end
            end
          end
        end
      end
    end
  end

  def listbanfiles
    @banlists = Banlist.all
  end

  def show
    @banlist = Banlist.find(params[:id])
    #@addrs = @banlist.addrs.all.paginate(:page => params[:page])
  end

  def edit
    @banlist = Banlist.find(params[:id])
  end

  def ban_addrs
    @banlist = Banlist.find(params[:id])
    @addrs = @banlist.addrs.all.paginate(:page => params[:page])
  end

  def update
    @banlist = Banlist.find(params[:id])

    respond_to do |format|
      if @banlist.update_attributes(params[:banlist])
        format.html { redirect_to @banlist, notice: 'Banlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @banlist.errors, status: :unprocessable_entity }
      end
    end
  end

end
