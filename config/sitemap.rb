# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.wheretobuycrypto.io"

SitemapGenerator::Sitemap.create do
  # /coins
  add coins_path, changefreq: 'daily'

  # /coins/:id
  Coin.all.each do |coin|
    add coin_path(coin), priority: 0.7, lastmod: coin.updated_at
  end

  # /exchanges
  add exchanges_path, changefreq: 'daily'
end
