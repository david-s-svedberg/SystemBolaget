class ArtikelNrGivare

  def initialize(filNamnHållare)
    @filNamnHållare = filNamnHållare
  end

  def tidigare_tillagda_artikel_nr()
    return läs_in_artikel_nr_från_fil(@filNamnHållare::TIDIGARE_TILLAGDA)
  end

  def uteslutna_artikel_nr()
    return läs_in_artikel_nr_från_fil(@filNamnHållare::UTESLUTNA)
  end

  def artikel_nr_som_visats_sakna_kollikrav()
    return läs_in_artikel_nr_från_fil(@filNamnHållare::KOLLIKRAV_SAKNAS)
  end

  def artikel_nr_som_visats_vara_beställningsbara()
    return läs_in_artikel_nr_från_fil(@filNamnHållare::BESTÄLLNINGSBARA)
  end

  private

    def läs_in_artikel_nr_från_fil(filnamn)
      artiklar = [-1]
      if(File.exist?(filnamn))
        file = File.open(filnamn, "r")
        artiklar.concat(file.each_line.to_a)
        file.close
      end
      return artiklar
    end

end
