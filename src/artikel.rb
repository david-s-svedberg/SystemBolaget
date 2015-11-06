require_relative '../lib/core_ext/node'

class Artikel
  attr_reader :sortiment, :artikelid, :namn, :namn2, :pris, :säljstart, :nr, :råvarorBeskrivning, :varugrupp, :alkoholhalt, :prisPerLiter, :volym

  def initialize(nr, artikelId, namn, namn2, pris, volym, prisPerLiter, säljstart, varugrupp, förpackning, ursprungsstad, ursprungsland, producent, alkoholhalt, sortiment, ekologiskt, råvarorBeskrivning)
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

end
