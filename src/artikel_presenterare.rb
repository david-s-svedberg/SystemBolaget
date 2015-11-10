require 'highline'

class ArtikelPresenterare

  def initialize(användarInformerare, artikelFiltrerare, användarFrågare, artikelHemsidoVisare, artikelNrSparare, valdaArtiklarHållare)
    @användarInformerare = användarInformerare
    @artikelFiltrerare = artikelFiltrerare
    @användarFrågare = användarFrågare
    @artikelHemsidoVisare = artikelHemsidoVisare
    @artikelNrSparare = artikelNrSparare
    @valdaArtiklarHållare = valdaArtiklarHållare
  end

  def presentera_artiklar(artiklar)
    antalBortfiltrerade = 0
    artiklar.each do |artikel|
      @användarInformerare.filtrerar(antalBortfiltrerade)
      if(@artikelFiltrerare.ska_visas?(artikel))
        @användarInformerare.clear_console()
        visa_artikel(artikel)
        begär_val_från_användaren(artikel)
      else
        antalBortfiltrerade += 1
      end
    end
  end

  private
    def visa_artikel(artikel)
      puts("Namn:           #{artikel.namn} #{artikel.namn2}")
      puts()
      puts("Varugrupp:      #{artikel.varugrupp}")
      visa_beskrivning(artikel)
      puts()
      puts("Producent:      #{artikel.producent}")
      puts("Pris:           #{artikel.pris}kr")
      puts("Alkoholhalt:    #{artikel.alkoholhalt}")
      puts("Volym:          #{artikel.volym}ml")
      puts("Pris per liter: #{artikel.prisPerLiter}kr")
      8.times.each do
        puts()
      end
    end

    def visa_beskrivning(artikel)
      consoleWidth = HighLine::SystemExtensions.terminal_size[0]
      header = "Beskrivning:    "
      lineLength = consoleWidth - header.length
      beskrivningsRader = artikel.råvarorBeskrivning.scan(/.{1,#{lineLength}}\W/).map(&:strip)
      if(!beskrivningsRader.empty?)
        beskrivningsRader.each_with_index do |rad, index|
          if(index == 0)
            puts(header + rad)
          else
            header.length.times {rad = " " + rad}
            puts rad
          end
        end
      end
    end

    def begär_val_från_användaren(artikel)
      @användarInformerare.val_för_visad_artikel()
      val = ''
      while(!val.match("l|u|s|a"))
        val = @användarFrågare.begär_val_för_visad_artikel()
        hantera_användarens_val(val, artikel)
      end
    end

    def hantera_användarens_val(val, artikel)
      case val
      when 'l'
        @valdaArtiklarHållare.lägg_till(artikel)
        @artikelNrSparare.spara_tillagd_artikel(artikel)
      when 'ö'
        @artikelHemsidoVisare.visa(artikel)
      when 'u'
        @artikelNrSparare.spara_utesluten_artikel(artikel)
      when 's'
      when 'a'
        exit()
      end
    end

end
