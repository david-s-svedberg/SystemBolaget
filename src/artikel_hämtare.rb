require 'nokogiri'

class ArtikelHämtare

 def initialize(xmlHämtare, xpathQueryGenerator, artikelFactory)
  @xmlHämtare = xmlHämtare
  @xpathQueryGenerator = xpathQueryGenerator
  @artikelFactory = artikelFactory
 end

 def hämta_artiklar()
  artiklarXml = Nokogiri::XML(@xmlHämtare.hämta_xml())
  query = @xpathQueryGenerator.skapa_query()
  artikelNoder = artiklarXml.xpath(query)

  return @artikelFactory.skapa_artiklar_från_noder(artikelNoder)
 end

end
