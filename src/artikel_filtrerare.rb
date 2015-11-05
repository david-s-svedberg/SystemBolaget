class ArtikelFiltrerare

  def initialize(valGivare, artikelNrGivare, hemsidoKontrollerare)
    @valGivare = valGivare
    @artikelNrGivare = artikelNrGivare
    @hemsidoKontrollerare = hemsidoKontrollerare
    @artikelNrGivare = artikelNrGivare
  end

  def ska_visas?(artikel)
    ret = true

    if(någon_filtrering_aktiv?())
      ret = @hemsidoKontrollerare.passerade_kontroll?(artikel)
    end

    return ret
  end

  private

    def någon_filtrering_aktiv?()
      return @valGivare.visa_artiklar_med_kollikrav?() or \
             @valGivare.visa_artiklar_som_ej_går_att_beställa?() or \
             @valGivare.visa_artiklar_som_är_tillfälligt_slut?()
    end

end
