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
      if fname.include?('.acl')
        all_acls.push(fname.sub('.acl', ''))
        i = i + 1
        file = File.open(squid_path + '\\' + fname, 'r')
        file.each { |line|
          all_users.push(line + ',' + i.to_s)
        }
      end
    end
    @users = all_users
    @groups = all_acls
  end

  def squid
    all_acls = Group.all
    eos = "\n"
    squid_path = '/etc/squid/'
    squid = squid_path + 'squid.conf'
    squid_conf = File.readlines(squid)
    all_acls.each do |acl|
      unless squid_conf.join.include?('acl '+acl.name+'_acman src "'+acl.name+'.acl"')
        pos = squid_conf.index('acl CONNECT method CONNECT'+eos)
        squid_conf.insert(pos+1, 'acl '+acl.name+'_acman src "'+acl.name+'.acl"')
      end
      unless squid_conf.join.include?('http_access allow '+acl.name+'_acman')
        pos = squid_conf.index('http_access allow localhost'+eos)
        squid_conf.insert(pos+1, 'http_access allow '+acl.name+'_acman')
      end
    end
    File.open('/tmp/squid.conf.new', 'w').write(squid_conf.join)
    system '/usr/bin/sudo /bin/cp /tmp/squid.conf.new ' + squid_path + 'squid.conf'
    system '/usr/bin/sudo /usr/sbin/squid -k reconfigure'
    @squid = squid_conf
  end
end
