class ArtikelFiltrerare

  def initialize(valGivare, hemsidoKontrollerare)
    @valGivare = valGivare
    @hemsidoKontrollerare = hemsidoKontrollerare
  end

  def ska_visas?(artikel)
    if(någon_filtrering_aktiv?())
      return @hemsidoKontrollerare.passerar_kontroll?(artikel)
    else
      return true
    end
  end

  private

    def någon_filtrering_aktiv?()
      return !@valGivare.visa_artiklar_med_kollikrav?() || \
             !@valGivare.visa_artiklar_som_ej_går_att_beställa?() || \
             !@valGivare.visa_artiklar_som_är_tillfälligt_slut?()
    end

end
