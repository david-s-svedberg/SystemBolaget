require 'open-uri'
require "net/http"

class HemsidoHämtare

  def initialize(websiteURLGenerator)
    @websiteURLGenerator = websiteURLGenerator
  end

  def hemsida_finns?(artikel)
    url = URI.parse(@websiteURLGenerator.generera_artikelhemsida(artikel))
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)
    return res.code == "200"
  end

  def hämta_hemsida(artikel)
    content = nil
    open(@websiteURLGenerator.generera_artikelhemsida(artikel)) do |io|
      content = io.read
    end
    return content
  end

  def artikelsHemsidaUrl(artikel)
    return @websiteURLGenerator.generera_artikelhemsida(artikel)
  end

end
