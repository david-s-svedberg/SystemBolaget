require_relative 'fil_namn_hållare'

class ArtikelNrGivare

  def tidigare_tillagda_artikel_nr()
    return läs_in_artikel_nr_från_fil(FilNamnHållare::TIDIGARE_TILLAGDA)
  end

  def uteslutna_artikel_nr()
    return läs_in_artikel_nr_från_fil(FilNamnHållare::UTESLUTNA)
  end

  def artikel_nr_som_visats_sakna_kollikrav()
    return läs_in_artikel_nr_från_fil(FilNamnHållare::KOLLIKRAV_SAKNAS)
  end

  def artikel_nr_som_visats_ha_kollikrav()
    return läs_in_artikel_nr_från_fil(FilNamnHållare::KOLLIKRAV)
  end

  def artikel_nr_som_visats_vara_beställningsbara()
    return läs_in_artikel_nr_från_fil(FilNamnHållare::BESTÄLLNINGSBARA)
  end

  def artikel_nr_som_visats_vara_icke_beställningsbara()
    return läs_in_artikel_nr_från_fil(FilNamnHållare::INTE_BESTÄLLNINGSBARA)
  end

  private

    def läs_in_artikel_nr_från_fil(filnamn)
      artiklar = ['-1']
      if(File.exist?(filnamn))
        file = File.open(filnamn, "r")
        artiklar.concat(file.each_line.to_a)
        file.close
      end
      return artiklar
    end

end
