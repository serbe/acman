class PagesController < ApplicationController
  def home
    @title = 'Home'
  end

  def users
    @title = 'Users'
  end

  def acl
    all_acls = []
    all_users = []
    i = 0
    squid_path = 'd:\acman\etc\squid'
    Dir.foreach(squid_path) do |fname|
      if fname.include?('.acl') then
        all_acls.push(fname.sub('.acl', ''))
        i = i + 1
        file = File.open(squid_path + '\\' + fname, 'r')
        file.each {|line|
          all_users.push(line + ',' + i.to_s)
        }
      end
    end
    @users = all_users
    @groups = all_acls
  end

end
