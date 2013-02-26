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
    squid_path = '/etc/squid'
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

    Dir.foreach(squid_path) do |fname|
      if fname.include?('.acl')
        system '/usr/bin/sudo /bin/rm ' + squid_path + fname
      end
    end

    squid = squid_path + 'squid.conf'
    squid_conf = File.readlines(squid)
    squid_conf.each do |line|
      if line.include?('_acman.acl"')
        squid_conf.delete(line)
      end
    end

    new_squid_conf = squid_conf
    all_acls.each do |acl|
      acl_file = File.open('/tmp/' + acl.name + '.acl', 'w')
      User.where(:team => acl.name).each do |item|
        acl_file.write(item.ip + eos)
      end
      acl_file.close
      system '/usr/bin/sudo /bin/cp /tmp/' + acl.name + '_acman.acl ' + squid_path
      system '/usr/bin/sudo /bin/chown root:root ' + squid_path + acl.name + '_acman.acl'
      system '/usr/bin/sudo /bin/rm /tmp/' + acl.name + '_acman.acl'

      unless new_squid_conf.join.include?('acl '+acl.name+'_acman src "'+squid_path+acl.name+'.acl"')
        pos = new_squid_conf.index('acl CONNECT method CONNECT'+eos)
        new_squid_conf.insert(pos+1, 'acl '+acl.name+'_acman src "'+squid_path+acl.name+'_acman.acl"'+eos)
      end
      unless new_squid_conf.join.include?('http_access allow '+acl.name+'_acman')
        pos = new_squid_conf.index('http_access allow localhost'+eos)
        new_squid_conf.insert(pos+1, 'http_access allow '+acl.name+'_acman'+eos)
      end
    end
    File.open('/tmp/squid.conf.new', 'w').write(squid_conf.join)
    system '/usr/bin/sudo /bin/cp /tmp/squid.conf.new ' + squid_path + 'squid.conf'
    system '/usr/bin/sudo /bin/chown root:root ' + squid_path + 'squid.conf'
    system '/usr/bin/sudo /bin/rm /tmp/squid.conf.new'
    system '/usr/bin/sudo /usr/sbin/squid -k reconfigure'
    @squid = new_squid_conf
  end

  #Создание списка для free-sa
  free_sa = File.open('/tmp/users', 'w')
  User.all.each do |item|
    free_sa.write(item.ip + ' ' + item.surname + ' ' + item.name + ' ' + item.s_name)
  end
  free_sa.close
  system '/usr/bin/sudo /bin/cp /tmp/users /etc/free-sa/users'
  system '/usr/bin/sudo /bin/chown root:root /etc/free-sa/users'
  system '/usr/bin/sudo /bin/rm /tmp/users'
end
