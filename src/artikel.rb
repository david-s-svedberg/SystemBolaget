require_relative '../lib/core_ext/node'

class Artikel
  attr_reader :ekologiskt, :producent, :ursprungsland, :ursprungsstad, :förpackning, :sortiment, :artikelid, :namn, :namn2, :pris, :säljstart, :nr, :råvarorBeskrivning, :varugrupp, :alkoholhalt, :prisPerLiter, :volym

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

  def ==(other)
    # ret = true
    # i = 0
    # self.state.each do |value|
    #   if(value != other.state[i])
    #     puts("#{value} (class:#{value.class}) != #{other.state[i]} (class:#{other.state[i].class})")
    #     ret = false
    #   end
    #   i += 1
    # end
    # return ret
    return self.class == other.class && self.state == other.state
  end

  def to_s
    ret = ""
    state.each do |value|
      ret += value.to_s + "\n"
    end
    return ret
  end

  protected

  def state
    [
      @nr,
      @artikelid,
      @namn,
      @namn2,
      @pris,
      @volym,
      @prisPerLiter,
      @säljstart,
      @varugrupp,
      @förpackning,
      @ursprungsstad,
      @ursprungsland,
      @producent,
      @alkoholhalt,
      @sortiment,
      @ekologiskt,
      @råvarorBeskrivning
    ]
  end

end
