class ArtikelPresenterare

  def initialize(användarInformerare, artikelFiltrerare, användarFrågare, artikelHemsidoVisare, artikelNrSparare)
    @användarInformerare = användarInformerare
    @artikelFiltrerare = artikelFiltrerare
    @användarFrågare = användarFrågare
    @artikelHemsidoVisare = artikelHemsidoVisare
    @artikelNrSparare = artikelNrSparare
  end

  def presentera_artiklar(artiklar)
    antalBortfiltrerade = 0
    artiklar.each do |artikel|
      @användarInformerare.filtrerar(antalBortfiltrerade)
      if(@artikelFiltrerare.ska_visas?())
        visa_artikel(artikel)
        hantera_användarens_val(@användarFrågare.begär_val_för_visad_artikel(), artikel)
      else
        antalBortfiltrerade += 1
      end
    end
  end

  private
    def visa_artikel()
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

    def hantera_användarens_val(val, artikel)
      case val
      when :lägg_till
        @valdaArtiklarHållare.lägg_till(artikel)
        @artikelNrSparare.spara_tillagd_artikel(artikel)
      when :öppna_hemsida
        @artikelHemsidoVisare.visa(artikel)
      when :uteslut
        @artikelNrSparare.spara_utesluten_artikel(artikel)
      when :skippa
      when :avsluta
        exit()
      end
    end

end
