#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'
require 'optparse'
require 'io/console'
require 'highline'
require 'launchy'
require "net/http"
require_relative 'lib/core_ext/string'
require_relative 'lib/core_ext/node'

class Artikel
  attr_reader :sortiment, :artikelid, :namn, :namn2, :pris, :säljstart, :nr, :råvarorBeskrivning, :varugrupp, :alkoholhalt, :prisPerLiter, :volym

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
SAKNAR_KOLLIKRAV_ARTIKLAR_FILNAMN = "saknar_kollikrav.dat"
GÅR_ATT_BESTÄLLA_ARTIKLAR_FILNAMN = "går_att_beställa.dat"

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
  File.open(UTESLUTNA_ARTIKLAR_FILNAMN, "a+") do |file|
    file.puts(artikel.nr) unless file.read.include?(artikel.nr)
  end
end

def sparaValdArtikel(artikel)
  File.open(VALDA_ARTIKLAR_FILNAMN, "a") do |file|
    file.puts(artikel.nr)
  end
end

def sparaSaknarKollikrav(artikel)
  File.open(SAKNAR_KOLLIKRAV_ARTIKLAR_FILNAMN, "a+") do |file|
    file.puts(artikel.nr) unless file.read.include?(artikel.nr)
  end
end

def sparaGårAttBeställa(artikel)
  File.open(GÅR_ATT_BESTÄLLA_ARTIKLAR_FILNAMN, "a+") do |file|
    file.puts(artikel.nr) unless file.read.include?(artikel.nr)
  end
end

def läs_in_går_att_beställa()
  return läs_in_fil_artiklar(GÅR_ATT_BESTÄLLA_ARTIKLAR_FILNAMN)
end

def läs_in_saknar_kollikrav()
  return läs_in_fil_artiklar(SAKNAR_KOLLIKRAV_ARTIKLAR_FILNAMN)
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
  bas = "http://www.systembolaget.se/dryck/ol/"
  ersättningar = {
    'å' => 'a',
    'Å' => 'a',
    'ä' => 'a',
    'Ä' => 'a',
    'á' => 'a',
    'Á' => 'a',
    'à' => 'a',
    'À' => 'a',
    'ö' => 'o',
    'Ö' => 'o',
    'ø' => 'o',
    'Ø' => 'o',
    'ó' => 'o',
    'Ó' => 'o',
    'ò' => 'o',
    'Ò' => 'o',
    'è' => 'e',
    'È' => 'e',
    'é' => 'e',
    'É' => 'e',
    'ë' => 'e',
    'Ë' => 'e',
    ' &' => '',
    "'" => '',
    "´" => '',
    "`" => '',
    ":" => '',
    "." => '',
    "!" => '',
    "/" => '',
    ' ' => '-'
  }
  namn = artikel.namn
  ersättningar.each do |key, value|
    namn.gsub!(key, value)
  end
  namn.downcase!
  rest = namn + "-#{artikel.nr}"
  return bas + rest
end

def hanteraAnvändarensVal(artikel, valdaArtiklar)
  valGjort = false
  dryckTillagd = false
  while(!valGjort)
    val = STDIN.getch
    case val
      when 'l'
        valdaArtiklar << artikel
        sparaValdArtikel(artikel)
        valGjort = true
        dryckTillagd = true
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
  return dryckTillagd
end

def check_if_website_exists(site)
  url = URI.parse(site)
  req = Net::HTTP.new(url.host, url.port)
  res = req.request_head(url.path)
  return res.code == "200"
end

def website_contains(site, text)
  open(site) do |io|
    return io.read.include?(text)
  end
end

def kollikrav(artikel, saknarKollikrav)
  if(artikel.sortiment == "BS" and !saknarKollikrav.include?(artikel.nr))
    site = generera_artikelhemsida(artikel)
    if(check_if_website_exists(site))
      if(website_contains(site, "Kollikrav"))
        sparaUteslutenArtikel(artikel)
        return true
      else
        sparaSaknarKollikrav(artikel)
      end
    else
      puts("Websidan finns inte: #{site}")
      puts("Välj mellan: [S]kippa, [U]teslut eller [A]vbryt.")
      valGjort = false
      while(!valGjort)
        val = STDIN.getch
        case val
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
  end
  return false
end

def går_att_beställa(artikel, gårAttBeställa)
  if(artikel.sortiment == "TSLS" and !gårAttBeställa.include?(artikel.nr))
    site = generera_artikelhemsida(artikel)
    if(check_if_website_exists(site))
      if(website_contains(site, "Går inte att beställa till övriga butiker"))
        sparaUteslutenArtikel(artikel)
        return false
      else
        sparaGårAttBeställa(artikel)
      end
    else
      puts("Websidan finns inte: #{site}")
      puts("Välj mellan: [S]kippa, [U]teslut eller [A]vbryt.")
      valGjort = false
      while(!valGjort)
        val = STDIN.getch
        case val
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
  end
  return true
end


options = {}
options[:antal] = 100 #default
OptionParser.new do |opts|
  opts.banner = "Usage: test.rb [options]"

  opts.on('-a', '--antal Antal', 'Antal artiklar som ska visas') { |v| options[:antal] = v }
  opts.on('-s', '--framtidasäljstart', 'Om produkter med framtida säljstart ska visas') { |v| options[:framtida_säljstart] = v }
  opts.on('-b', '--butik Nummer', 'Nummer på system eller ombud som ska levereras till ') { |v| options[:system_bolag] = v }

end.parse!

# Geocoder.configure(

#   # geocoding service (see below for supported options):
#   :lookup => :google,

#   # IP address geocoding service (see below for supported options):
#   :ip_lookup => :maxmind,

#   # to use an API key:
#   :api_key => "AIzaSyBj8WqFaf4ovumLKyMA9vevFfuVLaHST5g",

#   # geocoding service request timeout, in seconds (default 3):
#   :timeout => 5,

#   # set default units to kilometers:
#   :units => :km,

#   # caching (see below for details):
#   :cache => {}

# )

clearConsole()

# stores = Nokogiri::XML(open('http://www.systembolaget.se/api/assortment/stores/xml'))
# stores = Nokogiri::XML(File.open('stores.xml'))
# storeAddress = ""
# if(options[:system_bolag])
#   storesQuery = "//ButikOmbud[./Nr = '#{options[:system_bolag]}']/."
#   storesNoder = stores.xpath(storesQuery)
#   raise "Finns inget system med det nummret" unless storesNoder.length > 0
#   raise "Finns flera system med det nummret" unless storesNoder.length == 1
#   storeAddress = storesNoder[0].get_childnode_text('Address1') + " " + storesNoder[0].get_childnode_text('Address4')
# else
#   puts("Ange ortsnamn för önskat system eller ombud:")
#   ortsnamn = gets().chomp.upcase.tr('åäö','ÅÄÖ')
#   storesQuery = "//ButikOmbud[./Address4 = '#{ortsnamn}']/."
#   puts(storesQuery)
#   storesNoder = stores.xpath(storesQuery)
#   raise "Finns inget system eller ombud på den orten" unless storesNoder.length > 0
#   if (storesNoder.length > 1)
#     puts("Det finns flera ombud eller system på vald ort, vänligen välj vilken som ska användas:")
#     nummer = 1;
#     storesNoder.each do |storeNod|
#       puts("#{nummer}: #{storeNod.get_childnode_text('Namn')} #{storeNod.get_childnode_text('Address1')}")
#       nummer += 1
#     end
#     valtNummer = gets().chomp.to_i
#     storeAddress = storesNoder[valtNummer - 1].get_childnode_text('Address1') + " " + storesNoder[valtNummer - 1].get_childnode_text('Address4')
#   else
#     storeAddress = storesNoder[0].get_childnode_text('Address1') + " " + storesNoder[0].get_childnode_text('Address4')
#   end
# end
# puts storeAddress
# geo = Geocoder.search(storeAddress)
# ll = geo[0].data["geometry"]["location"]
# puts("#{ll['lat']} #{ll['lng']}")
# storeLocation =
# # storesQuery =

puts("Fetching and filtering search...")
# products = Nokogiri::XML(open('http://www.systembolaget.se/api/assortment/products/xml'))
products = Nokogiri::XML(File.open('products.xml'))

varugrupper = ['Porter', 'Ale', 'Stout', 'Specialöl', 'Spontanjäst']
varugruppQuery = skapa_varugrupps_query(varugrupper).wrap_with_parenthesis()

# oönskadeSortiment = ['BS', 'TSLS', 'TSE']
# oönskadeSortimentQuery = skapa_oönskade_sortiment_query(oönskadeSortiment).wrap_with_parenthesis()

dagensDatum = DateTime.now
sälstartsQuery = skapa_säljstarts_query(dagensDatum).wrap_with_parenthesis()

antal = options[:antal]
antalQuery = skapa_antal_query(antal).wrap_with_parenthesis()

uteslutna = läs_in_uteslutna()
uteslutnaQuery = skapa_not_nr_query(uteslutna).wrap_with_parenthesis()

tidigareValda = läs_in_tidigare_valda()
tidigareValdaQuery = skapa_not_nr_query(tidigareValda).wrap_with_parenthesis()

productQuery = "//artikel[#{varugruppQuery} and #{sälstartsQuery} and #{uteslutnaQuery} and #{tidigareValdaQuery}]/."
# productQuery = "//artikel[#{varugruppQuery} and #{oönskadeSortimentQuery} and #{sälstartsQuery} and #{uteslutnaQuery} and #{tidigareValdaQuery}][#{antalQuery}]/."
artikelNoder = products.xpath(productQuery)
artiklar = []
artikelNoder.each do |node|
  artikel = Artikel.new(node)
  artiklar << artikel
end
filtreradeArtiklar = []
saknarKollikrav = läs_in_saknar_kollikrav()
gårAttBeställa = läs_in_går_att_beställa()
artiklar.each do |artikel|
  filtreradeArtiklar << artikel unless kollikrav(artikel, saknarKollikrav) or !går_att_beställa(artikel, gårAttBeställa) #or (avståndskrav(artikel) and för_långt(valtSystem, artikel))
end

valdaArtiklar = []
#puts query
tillagdaDrycker = 0
filtreradeArtiklar.each do |artikel|
  break if tillagdaDrycker >= options[:antal]
  clearConsole()
  visaArtikelInformation(artikel)
  visaMöjligaVal()
  if(hanteraAnvändarensVal(artikel, valdaArtiklar))
    tillagdaDrycker += 1
  end
end
clearConsole()
