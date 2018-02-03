class Coinmarketcal
  include HTTParty
  base_uri "coinmarketcal.com/api"

  def events(params = {})
    r = self.class.get("/events", { query: params })
    if r.success?
      JSON.parse(r.body)
    else
      false
    end
  end
end
