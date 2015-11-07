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
      puts(artikel.namn)
      puts(artikel.namn2)
      puts()
      puts(artikel.varugrupp)
      puts(artikel.råvarorBeskrivning)
      puts("#{artikel.pris}kr")
      puts(artikel.alkoholhalt)
      puts("#{artikel.volym}ml")
      puts("#{artikel.prisPerLiter}kr per liter")
      8.times.each do
        puts()
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
