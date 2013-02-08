class User < ActiveRecord::Base
  attr_accessible :group, :ip, :name, :s_name, :surname
end
