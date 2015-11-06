require 'open-uri'
require "net/http"

class HemsidoKontrollerare

  def initialize(valGivare, websiteURLGenerator, användarInformerare, användarFrågare, artikelNrSparare, artikelNrGivare)
    @valGivare = valGivare
    @websiteURLGenerator = websiteURLGenerator
    @användarInformerare = användarInformerare
    @användarFrågare = användarFrågare
    @artikelNrSparare = artikelNrSparare
    @artikelNrGivare = artikelNrGivare
  end

  def passerar_kontroll?(artikel)
    return false if kontroll_ska_göras_på_något_som_sen_tidigare_visats_falera(artikel)

    ret = true
    url = @websiteURLGenerator.generera()
    if(hemsidaFinns(url))
      webContent = hämta_hemsida(url)
      ret = passerar_alla_valda_kontroller?(artikel, webContent)
    else
      @användarInformerare.hemsida_finns_inte(url)
      val = @användarFrågare.begär_val_för_felaktig_hemsida()
      hantera_användarens_val(artikel, val)
      if(val != :visa_artikel)
        ret = false
      end
    end

    return ret
  end

  private

    def hemsida_finns?(url)
      url = URI.parse(url)
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      return res.code == "200"
    end

    def kontroll_ska_göras_på_något_som_sen_tidigare_visats_falera(artikel)
      return (kontrollera_kollikrav?() && har_sen_tidigare_visats_ha_kollikrav?(artikel)) || \
             (kontrollera_beställningsbarhet?() && har_sen_tidigare_visats_vara_icke_beställningsbar?(artikel))
    end

    def hämta_hemsida(url)
      content = nil
      open(url) do |io|
        content = io.read
      end
      return content
    end

    def kontrollera_tillfälligt_slut?()
      return !@valGivare.visa_artiklar_som_är_tillfälligt_slut?()
    end

    def kontrollera_kollikrav?(artikel)
      return !@valGivare.visa_artiklar_med_kollikrav?() && \
              är_beställnings_sortiment?(artikel) && \
             !har_sen_tidigare_visats_sakna_kollikrav?(artikel)
    end

    def kontrollera_beställningsbarhet?()
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
      return @artikelNrGivare.artikel_nr_som_visats_vara_icke_beställningsbara().contains(artikel.nr)
    end

    def har_sen_tidigare_visats_vara_beställningsbar?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_vara_beställningsbara().contains(artikel.nr)
    end

    def har_sen_tidigare_visats_sakna_kollikrav?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_sakna_kollikrav().contains(artikel.nr)
    end

    def har_sen_tidigare_visats_ha_kollikrav?(artikel)
      return @artikelNrGivare.artikel_nr_som_visats_ha_kollikrav.contains(artikel.nr)
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
      ret = true
      if(kontrollera_kollikrav?(artikel))
        if(!passerar_kollikrav_kontroll?(artikel, webContent))
          ret = false
        end
      end
      if(kontrollera_beställningsbarhet?(artikel))
        if(!passerar_beställningsbarhets_kontroll?(artikel, webContent))
          ret = false
        end
      end
      if(kontrollera_tillfälligt_slut?())
        if(!passerar_tillfälligt_slut_kontroll?(webContent))
          ret = false
        end
      end
      return ret
    end

    def hantera_användarens_val(artikel, val)
      case val
      when :uteslut
        @artikelNrSparare.spara_utesluten_artikel(artikel)
      when :avsluta
        exit()
      end
    end
end
