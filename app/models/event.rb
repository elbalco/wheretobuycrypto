class Event < ActiveRecord::Base
  serialize :data
  belongs_to :coin
  belongs_to :exchange
end
