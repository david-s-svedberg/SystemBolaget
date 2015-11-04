require_relative '../lib/core_ext/node'

class Artikel
  attr_reader :sortiment, :artikelid, :namn, :namn2, :pris, :säljstart, :nr, :råvarorBeskrivning, :varugrupp, :alkoholhalt, :prisPerLiter, :volym

  def initialize(nr, artikelId, namn, namn2, pris, volym, prisPerLiter, säljstart, varugrupp, förpackning, ursprungsstad, ursprungsstad, producent, alkoholhalt, sortiment, ekologiskt, råvarorBeskrivning)
    @nr = nr
    @artikelid = artikelid
    @namn = namn
    @namn2 = namn2
    @pris = pris
    @volym = volym
    @prisPerLiter = prisPerLiter
    @säljstart = säljstart
    @varugrupp = varugrupp
    @förpackning = förpackning
    @ursprungsstad = ursprungsstad
    @ursprungsland = ursprungsland
    @producent = producent
    @alkoholhalt = alkoholhalt
    @sortiment = sortiment
    @ekologiskt = ekologiskt
    @råvarorBeskrivning = råvarorBeskrivning
  end

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
