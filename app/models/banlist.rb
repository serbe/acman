class Banlist < ActiveRecord::Base
  has_many :addrs
  has_many :pcres
  attr_accessible :name
  validates :name, :presence => true,
            :uniqueness => true
end
