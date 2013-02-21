class Pcre < ActiveRecord::Base
  attr_accessible :banlist_id, :name
  belongs_to :banlist
end
