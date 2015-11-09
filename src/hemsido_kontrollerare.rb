class HemsidoKontrollerare

  def initialize(valGivare, hemsidoHämtare, användarInformerare, användarFrågare, artikelNrSparare, artikelNrGivare)
    @valGivare = valGivare
    @hemsidoHämtare = hemsidoHämtare
    @användarInformerare = användarInformerare
    @användarFrågare = användarFrågare
    @artikelNrSparare = artikelNrSparare
    @artikelNrGivare = artikelNrGivare
  end

  def passerar_kontroll?(artikel)
    return false if kontroll_ska_göras_på_något_som_sen_tidigare_visats_falera(artikel)

    ret = true
    if(@hemsidoHämtare.hemsida_finns?(artikel))
      webContent = @hemsidoHämtare.hämta_hemsida(artikel)
      ret = passerar_alla_valda_kontroller?(artikel, webContent)
    else
      @användarInformerare.hemsida_finns_inte(@hemsidoHämtare.artikelsHemsidaUrl(artikel))
      @användarInformerare.val_för_felaktig_hemsida()
      val = @användarFrågare.begär_val_för_felaktig_hemsida()
      hantera_användarens_val(artikel, val)
      if(val != 'v')
        ret = false
      end
    end

    return ret
  end

  private

    def kontroll_ska_göras_på_något_som_sen_tidigare_visats_falera(artikel)
      return (kontrollera_kollikrav?(artikel) && har_sen_tidigare_visats_ha_kollikrav?(artikel)) || \
             (kontrollera_beställningsbarhet?(artikel) && har_sen_tidigare_visats_vara_icke_beställningsbar?(artikel))
    end

    def kontrollera_tillfälligt_slut?()
      return !@valGivare.visa_artiklar_som_är_tillfälligt_slut?()
    end

    def kontrollera_kollikrav?(artikel)
      return !@valGivare.visa_artiklar_med_kollikrav?() && \
              är_beställnings_sortiment?(artikel) && \
             !har_sen_tidigare_visats_sakna_kollikrav?(artikel)
    end

    def kontrollera_beställningsbarhet?(artikel)
      return !@valGivare.visa_artiklar_som_ej_går_att_beställa?() && \
              är_lokalt_och_småskaligt_sortiment?(artikel) && \
             !har_sen_tidigare_visats_vara_beställningsbar?(artikel)
    end

    def är_beställnings_sortiment?(artikel)
      return artikel.sortiment == "BS"
    end

    def är_lokalt_och_småskaligt_sortiment?(artikel)
      return artikel.sortiment == "TSLS"
    end

    def har_sen_tidigare_visats_vara_icke_beställningsbar?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_vara_icke_beställningsbara().include?(artikel.nr)
    end

    def har_sen_tidigare_visats_vara_beställningsbar?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_vara_beställningsbara().include?(artikel.nr)
    end

    def har_sen_tidigare_visats_sakna_kollikrav?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_sakna_kollikrav().include?(artikel.nr)
    end

    def har_sen_tidigare_visats_ha_kollikrav?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_ha_kollikrav.include?(artikel.nr)
    end

    def passerar_kollikrav_kontroll?(artikel, webContent)
      if(webContent.include?("Kollikrav"))
        @artikelNrSparare.spara_har_kollikrav(artikel)
        return false
      else
        @artikelNrSparare.spara_saknar_kollikrav(artikel)
        return true
      end
    end

    def passerar_beställningsbarhets_kontroll?(artikel, webContent)
      if(webContent.include?("Går inte att beställa till övriga butiker"))
        @artikelNrSparare.spara_inte_beställningsbar(artikel)
        return false
      else
        @artikelNrSparare.spara_beställningsbar(artikel)
        return true
      end
    end

    def passerar_tillfälligt_slut_kontroll?(webContent)
      if(webContent.include?("Tillfälligt slut"))
        return false
      else
        return true
      end
    end

    def passerar_alla_valda_kontroller?(artikel, webContent)
      passerarKontrollerna = true

      if(kontrollera_kollikrav?(artikel))
        if(!passerar_kollikrav_kontroll?(artikel, webContent))
          passerarKontrollerna = false
        end
      end
      if(kontrollera_beställningsbarhet?(artikel))
        if(!passerar_beställningsbarhets_kontroll?(artikel, webContent))
          passerarKontrollerna = false
        end
      end
      if(passerarKontrollerna)
        if(kontrollera_tillfälligt_slut?())
          if(!passerar_tillfälligt_slut_kontroll?(webContent))
            passerarKontrollerna = false
          end
        end
      end
      return passerarKontrollerna
    end

    def hantera_användarens_val(artikel, val)
      case val
      when 'u'
        @artikelNrSparare.spara_utesluten_artikel(artikel)
      when 'a'
        exit()
      end
    end
end
