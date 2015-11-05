require 'open-uri'

class HemsidoKontrollerare

  def initialize(valGivare, websiteURLGenerator, användarInformerare, användarFrågare, artikelNrSparare, artikelNrGivare)
    @valGivare = valGivare
    @websiteURLGenerator = websiteURLGenerator
    @användarInformerare = användarInformerare
    @användarFrågare = användarFrågare
    @artikelNrSparare = artikelNrSparare
    @artikelNrGivare = artikelNrGivare
  end

  def passerade_kontroll?(artikel)
    ret = true
    url = @websiteURLGenerator.generera()
    if(hemsidaFinns(url))
      webContent = hämta_hemsida(url)
      if(kontrollera_kollikrav?(artikel))
        if(!webContent.include?("Kollikrav"))
          @artikelNrSparare.spara_saknar_kollikrav(artikel)
          return false
        end
      end
      if(kontrollera_kollikrav?(artikel))

      end
      if(kontrollera_tillfälligt_slut?(artikel))

      end
    else

    end

    return ret
  end

  private

    def hämta_hemsida(url)
      content = nil
      open(url) do |io|
        content = io.read
      end
      return content
    end

    def kontrollera_tillfälligt_slut?(artikel)

    end

    def kontrollera_kollikrav?(artikel)
      return !@valGivare.visa_artiklar_med_kollikrav?() and \
              är_beställnings_sortiment?(artikel) and \
             !har_sen_tidigare_visats_sakna_kollikrav?(artikel)
    end

    def kontrollera_beställningsbarhet?()
      return !@valGivare.visa_artiklar_som_ej_går_att_beställa?() and \
              är_lokalt_och_småskaligt_sortiment?(artikel) and \
             !har_sen_tidigare_visats_vara_beställningsbar?(artikel)
    end

    def är_beställnings_sortiment?(artikel)
      return artikel.sortiment == "BS"
    end

    def är_lokalt_och_småskaligt_sortiment?(artikel)
      return artikel.sortiment == "TSLS"
    end

    end

    def har_sen_tidigare_visats_vara_beställningsbar?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_vara_beställningsbara().contains(artikel.nr)
    end

    def har_sen_tidigare_visats_sakna_kollikrav?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_sakna_kollikrav().contains(artikel.nr)
    end

end
