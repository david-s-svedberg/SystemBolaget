class XpathQueryGenerator

  def initialize(valGivare, datumGivare, artikelNrGivare)
    @valGivare = valGivare
    @datumGivare = datumGivare
    @artikelNrGivare = artikelNrGivare
  end

  def skapa_query()
    queryDelar = []
    queryDelar << skapa_varugrupp_query().wrap_with_parenthesis() unless !@valGivare.begränsa_varugrupper?()
    queryDelar << skapa_oönskade_sortiment_query().wrap_with_parenthesis() unless !@valGivare.begränsa_sortimen?()
    queryDelar << skapa_säljstarts_query().wrap_with_parenthesis() unless @valGivare.visa_artiklar_med_framtida_säljstart()
    queryDelar << skapa_uteslut_tidigare_tillagda_query().wrap_with_parenthesis() unless @valGivare.visa_tidigare_tillagda_artiklar?
  end

  private

    def skapa_varugrupp_query()
      valdaVarugrupper = @valGivare.valda_varugrupper()
      delar = []
      valdaVarugrupper.each do |varugrupp|
        delar << "contains(./Varugrupp/text(), '#{varugrupp}')"
      end
      return delar.join(' or ')
    end

    def skapa_oönskade_sortiment_query()
      oönskadeSortiment = @valGivare.oönskade_sortiment()
      delar = []
      oönskadeSortiment.each do |sortiment|
        delar << "./Sortiment = '#{sortiment}'"
      end
      return delar.join(' or ').wrap('not(', ')')
    end

    def skapa_uteslut_tidigare_tillagda_query()
      tidigareTillagdaArtikelNr = @artikelNrGivare.tidigare_tillagda_artikel_nr()
    end

    def skapa_not_nr_query(artiklar)
      arr = []
      artiklar.each do |artikel|
        arr << "./nr = #{artikel}"
      end
      return arr.join(' or ').wrap('not(', ')')
    end

    def skapa_säljstarts_query()
      dagensDatum = @datumGivare.dagens_datum()

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

end
