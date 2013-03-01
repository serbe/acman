require 'resolv'
class User < ActiveRecord::Base
  attr_accessible :team, :ip, :name, :s_name, :surname, :macadress, :compmame
  validates :name, :presence => true,
            :length => { :maximum => 50 }
  validates :ip, :presence => true,
            :uniqueness => true,
            :format => { :with => Resolv::IPv4::Regex }
end
