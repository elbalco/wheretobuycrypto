class Event < ActiveRecord::Base
  belongs_to :coin
  belongs_to :exchange
end
