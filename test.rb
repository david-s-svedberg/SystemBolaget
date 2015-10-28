#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

class String
  def wrap(pre, post)
    return self.prepend(pre) << post
  end

  def wrap_with_parenthesis()
    return self.wrap('(', ')')
  end
end

class Nokogiri::XML::Node
  def get_childnode_text(childNodeName)
    self.>(childNodeName).text
  end
end

class Artikel
  attr_reader :artikelid, :namn, :pris, :säljstart

  def initialize(node)
    @artikelid = node.get_childnode_text('Artikelid')
    @namn = node.get_childnode_text('Namn') + " " + node.get_childnode_text('Namn2')
    @pris = node.get_childnode_text('Prisinklmoms').to_f
    @volym = node.get_childnode_text('Volymiml').to_f
    @prisPerLiter = node.get_childnode_text('PrisPerLiter').to_f
    @säljstart = DateTime.strptime(node.get_childnode_text('Saljstart'), '%Y-%m-%d')
    @varugrupp = node.get_childnode_text('Varugrupp')
    @förpackning = node.get_childnode_text('Forpackning')
    @ursprungsstad = node.get_childnode_text('Ursprung')
    @ursprungsland = node.get_childnode_text('Ursprunglandnamn')
    @producent = node.get_childnode_text('Producent')
    @alkoholhalt = node.get_childnode_text('Alkoholhalt')
    @sortiment = node.get_childnode_text('Sortiment')
    @ekologiskt = !node.get_childnode_text('Ekologisk').to_i.zero?
  end

  def to_s
    "#{@namn} #{@varugrupp} #{@alkoholhalt} #{@pris}kr"
  end
end

def skapa_varugrupps_query(varugrupper)
  varugruppQueryArray = []
  varugrupper.each do |varugrupp|
    varugruppQueryArray << "contains(./Varugrupp/text(), '#{varugrupp}')"
  end
  return varugruppQueryArray.join(' or ')
end

def skapa_oönskade_sortiment_query(oönskadeSortiment)
  oönskadeSortimentArray = []
  oönskadeSortiment.each do |sortiment|
    oönskadeSortimentArray << "./Sortiment = '#{sortiment}'"
  end
  return oönskadeSortimentArray.join(' or ').wrap('not(', ')')
end

#products = Nokogiri::XML(open('http://www.systembolaget.se/api/assortment/products/xml'))
products = Nokogiri::XML(File.open('products.xml'))

varugrupper = ['Porter', 'Ale', 'Stout', 'Specialöl', 'Spontanjäst']
varugruppQuery = skapa_varugrupps_query(varugrupper).wrap_with_parenthesis()

oönskadeSortiment = ['BS', 'TSLS', 'TSE']
oönskadeSortimentQuery = skapa_oönskade_sortiment_query(oönskadeSortiment).wrap_with_parenthesis()

query = "//artikel[#{varugruppQuery} and #{oönskadeSortimentQuery}]/."
artikelNoder = products.xpath(query)
artiklar = []
artikelNoder.each do |node|
  artikel = Artikel.new(node)
  artiklar << artikel unless artikel.säljstart > DateTime.now
end
puts(artiklar)
puts(artiklar.length)
