#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'
require 'optparse'
require 'io/console'
require 'highline'
require 'launchy'

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
  attr_reader :artikelid, :namn, :namn2, :pris, :säljstart, :nr, :råvarorBeskrivning, :varugrupp, :alkoholhalt, :prisPerLiter, :volym

  def initialize(node)
    @nr = node.get_childnode_text('nr')
    @artikelid = node.get_childnode_text('Artikelid')
    @namn = node.get_childnode_text('Namn')
    @namn2 = node.get_childnode_text('Namn2')
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
    @råvarorBeskrivning = node.get_childnode_text('RavarorBeskrivning')
  end

  def to_s
    "#{@namn} #{@varugrupp} #{@alkoholhalt} #{@pris}kr"
  end
end

VALDA_ARTIKLAR_FILNAMN = "tidigare_valda.dat"
UTESLUTNA_ARTIKLAR_FILNAMN = "uteslutna.dat"

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

def skapa_not_nr_query(artiklar)
  arr = []
  artiklar.each do |artikel|
    arr << "./nr = #{artikel}"
  end
  return arr.join(' or ').wrap('not(', ')')
end

def clearConsole()
  puts "\e[H\e[2J"
end

def skapa_antal_query(antal)
  return "position()<=#{antal}"
end

def skapa_säljstarts_query(dagensDatum)
  year = dagensDatum.year
  month = dagensDatum.month
  day = dagensDatum.day

  lessThanYear = skapa_mindre_än_datum_sub_query(1,4,year)
  sameYear = skapa_samma_datum_sub_query(1,4,year)
  lessThanMonth = skapa_mindre_än_datum_sub_query(6,2,month)
  sameMonth = skapa_samma_datum_sub_query(6,2,month)
  lessThanOrEqualDay = skapa_mindre_än_eller_samma_datum_sub_query(9,2,day)

  return "#{lessThanYear} or (#{sameYear} and #{lessThanMonth}) or (#{sameYear} and #{sameMonth} and #{lessThanOrEqualDay})"
end

def skapa_mindre_än_eller_samma_datum_sub_query(startIndex, endIndex, value)
  skapa_jämför_datum_sub_query(startIndex,endIndex,"<=",value)
end

def skapa_mindre_än_datum_sub_query(startIndex, endIndex, value)
  skapa_jämför_datum_sub_query(startIndex,endIndex,"<",value)
end

def skapa_samma_datum_sub_query(startIndex, endIndex, value)
  skapa_jämför_datum_sub_query(startIndex,endIndex,"=",value)
end

def skapa_jämför_datum_sub_query(startIndex, endIndex, jämförelse, value)
  "number(substring(./Saljstart/text(),#{startIndex},#{endIndex})) #{jämförelse} #{value}"
end

def visaArtikelInformation(artikel)
  puts(artikel.namn)
  puts(artikel.namn2)
  puts()
  puts(artikel.varugrupp)
  puts("#{artikel.råvarorBeskrivning}")
  puts("#{artikel.pris}kr")
  puts("#{artikel.alkoholhalt}")
  puts("#{artikel.volym}ml")
  puts("#{artikel.prisPerLiter}kr per liter")
  (HighLine::SystemExtensions.terminal_size[1] - 12).times.each do
    puts()
  end
end

def visaMöjligaVal()
  puts("Välj mellan: [L]ägg till, [S]kippa, [U]teslut, [Ö]ppna hemsida eller [A]vbryt.")
end

def sparaUteslutenArtikel(artikel)
  File.open(UTESLUTNA_ARTIKLAR_FILNAMN, "a") do |file|
    file.puts(artikel.nr)
  end
end

def sparaValdArtikel(artikel)
  File.open(VALDA_ARTIKLAR_FILNAMN, "a") do |file|
    file.puts(artikel.nr)
  end
end

def läs_in_uteslutna()
  return läs_in_fil_artiklar(UTESLUTNA_ARTIKLAR_FILNAMN)
end

def läs_in_tidigare_valda()
  return läs_in_fil_artiklar(VALDA_ARTIKLAR_FILNAMN)
end

def läs_in_fil_artiklar(filnamn)
  artiklar = [-1]
  if(File.exist?(filnamn))
    file = File.open(filnamn, "r")
    artiklar.concat(file.each_line.to_a)
    file.close
  end
  return artiklar
end

def generera_artikelhemsida(artikel)
  return "http://www.systembolaget.se/dryck/ol/#{artikel.namn.sub('å', 'a').sub('ä', 'a').sub('ö', 'o').gsub(' ', '-').downcase}-#{artikel.nr}"
end

def hanteraAnvändarensVal(artikel, valdaArtiklar)
  valGjort = false
  while(!valGjort)
    val = STDIN.getch
    case val
      when 'l'
        valdaArtiklar << artikel
        sparaValdArtikel(artikel)
        Launchy.open(generera_artikelhemsida(artikel))
        valGjort = true
      when 'ö'
        Launchy.open(generera_artikelhemsida(artikel))
      when 'u'
        sparaUteslutenArtikel(artikel)
        valGjort = true
      when 's'
        valGjort = true
      when 'a'
        clearConsole()
        exit()
        valGjort = true
    end
  end
end

options = {}
options[:antal] = 100 #default
OptionParser.new do |opts|
  opts.banner = "Usage: test.rb [options]"

  opts.on('-a', '--antal Antal', 'Antal artiklar som ska visas') { |v| options[:antal] = v }
  opts.on('-s', '--framtidasäljstart', 'Om produkter med framtida säljstart ska visas') { |v| options[:framtida_säljstart] = v }

end.parse!

clearConsole()
puts("Fetching and filtering search...")
#products = Nokogiri::XML(open('http://www.systembolaget.se/api/assortment/products/xml'))
products = Nokogiri::XML(File.open('products.xml'))

varugrupper = ['Porter', 'Ale', 'Stout', 'Specialöl', 'Spontanjäst']
varugruppQuery = skapa_varugrupps_query(varugrupper).wrap_with_parenthesis()

oönskadeSortiment = ['BS', 'TSLS', 'TSE']
oönskadeSortimentQuery = skapa_oönskade_sortiment_query(oönskadeSortiment).wrap_with_parenthesis()

dagensDatum = DateTime.now
sälstartsQuery = skapa_säljstarts_query(dagensDatum).wrap_with_parenthesis()

antal = options[:antal]
antalQuery = skapa_antal_query(antal).wrap_with_parenthesis()

uteslutna = läs_in_uteslutna()
uteslutnaQuery = skapa_not_nr_query(uteslutna).wrap_with_parenthesis()

tidigareValda = läs_in_tidigare_valda()
tidigareValdaQuery = skapa_not_nr_query(tidigareValda).wrap_with_parenthesis()

query = "//artikel[#{varugruppQuery} and #{oönskadeSortimentQuery} and #{sälstartsQuery} and #{uteslutnaQuery} and #{tidigareValdaQuery}][#{antalQuery}]/."
artikelNoder = products.xpath(query)
artiklar = []
artikelNoder.each do |node|
  artikel = Artikel.new(node)
  artiklar << artikel
end
valdaArtiklar = []
#puts query
artiklar.each do |artikel|
  clearConsole()
  visaArtikelInformation(artikel)
  visaMöjligaVal()
  hanteraAnvändarensVal(artikel, valdaArtiklar)
end
clearConsole()
