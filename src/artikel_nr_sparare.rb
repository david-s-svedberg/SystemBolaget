require_relative 'fil_namn_hållare'

require 'fileutils'

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

  def spara_inte_beställningsbar(artikel)
    spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, FilNamnHållare::INTE_BESTÄLLNINGSBARA)
  end

  def spara_artikel_nr(artikel, filnamn)
    make_sure_bin_dir_exists()
    File.open(filnamn, "a+") do |file|
      file.puts(artikel.nr)
    end
  end

  def spara_artikel_nr_om_det_inte_redan_är_sparat(artikel, filnamn)
    make_sure_bin_dir_exists()
    File.open(filnamn, "a+") do |file|
      file.puts(artikel.nr) unless file.read.include?(artikel.nr.to_s)
    end
  end

  def make_sure_bin_dir_exists()
    unless File.directory?(FilNamnHållare::BIN_PATH)
      FileUtils.mkdir_p(FilNamnHållare::BIN_PATH)
    end
  end

end
