require 'launchy'

class ArtikelHemsidoVisare

  def initialize(websiteURLGenerator)
    @websiteURLGenerator = websiteURLGenerator
  end

  def visa(artikel)
    Launchy.open(@websiteURLGenerator.generera(artikel))
  end

end
