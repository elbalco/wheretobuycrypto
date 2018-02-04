class EventSerializer < ActiveModel::Serializer
  attributes :exchange, :will_happen_at

  def will_happen_at
    object.will_happen_at.to_date.to_s
  end
end
