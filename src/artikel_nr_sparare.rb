require_relative 'fil_namn_hållare'

class ArtikelNrSparare

  def spara_tillagd_artikel(artikel)
    spara_artikel_nr(artikel, FilNamnHållare::TIDIGARE_TILLAGDA)
  end

  def spara_utesluten_artikel(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, FilNamnHållare::UTESLUTNA)
  end

  def spara_har_kollikrav(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, FilNamnHållare::KOLLIKRAV)
  end

  def spara_saknar_kollikrav(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, FilNamnHållare::KOLLIKRAV_SAKNAS)
  end

  def spara_beställningsbar(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, FilNamnHållare::BESTÄLLNINGSBARA)
  end

  def spara_artikel_nr(artikel, filnamn)
    File.open(filnamn, "a") do |file|
      file.puts(artikel.nr)
    end
  end

  def spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, filnamn)
    File.open(filnamn, "a+") do |file|
      file.puts(artikel.nr) unless file.read.include?(artikel.nr)
    end
  end

end
