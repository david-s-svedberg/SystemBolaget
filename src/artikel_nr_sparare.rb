class ArtikelNrSparare

  def initialize(filNamnHållare)
    @filNamnHållare = filNamnHållare
  end

  def spara_tillagd_artikel(artikel)
    spara_artikel_nr(artikel, @filNamnHållare::TIDIGARE_TILLAGDA)
  end

  def spara_utesluten_artikel(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, @filNamnHållare::UTESLUTNA)
  end

  def spara_saknar_kollikrav(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, @filNamnHållare::KOLLIKRAV_SAKNAS)
  end

  def spara_beställningsbar(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, @filNamnHållare::BESTÄLLNINGSBARA)
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
