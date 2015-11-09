require_relative '../helpers/artikel_test_helper'

require 'test/unit'
require 'mocha/test_unit'

class WebFiltrering < Test::Unit::TestCase
  include ArtikelTestHelper

  def setup()
    @sut = get_sut()
  end

  def test_filtrerar_kollikrav()
    medKollikrav = skapa_artikel(nr: 1, sortiment: 'BS')
    medKollikrav2 = skapa_artikel(nr: 2, sortiment: 'BS')
    utanKollikrav = skapa_artikel(nr: 3, sortiment: 'BS')
    utanKollikrav2 = skapa_artikel(nr: 4, sortiment: 'BS')
    sätt_upp_artiklar(medKollikrav, medKollikrav2, utanKollikrav, utanKollikrav2)
    filtrera_kollikrav(medKollikrav, medKollikrav2)
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(utanKollikrav, utanKollikrav2)
    dölj_utskrifter()
    spara_inte_artikel_nr()
    @sut.run()
  end

  def test_filtrerar_beställningsbar()
    beställningsbar = skapa_artikel(nr: 1, sortiment: 'TSLS')
    beställningsbar2 = skapa_artikel(nr: 2, sortiment: 'TSLS')
    inteBeställningsbar = skapa_artikel(nr: 3, sortiment: 'TSLS')
    inteBeställningsbar2 = skapa_artikel(nr: 4, sortiment: 'TSLS')
    sätt_upp_artiklar(beställningsbar, beställningsbar2, inteBeställningsbar, inteBeställningsbar2)
    filtrera_ej_beställningsbara(inteBeställningsbar, inteBeställningsbar2)
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(beställningsbar, beställningsbar2)
    dölj_utskrifter()
    spara_inte_artikel_nr()
    @sut.run()
  end

  def test_filtrerar_tillfälligt_slut()
    slut = skapa_artikel(nr: 1)
    slut2 = skapa_artikel(nr: 2)
    inteSlut = skapa_artikel(nr: 3)
    inteSlut2 = skapa_artikel(nr: 4)
    sätt_upp_artiklar(slut, slut2, inteSlut, inteSlut2)
    filtrera_tillfälligt_slut(slut, slut2)
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(inteSlut, inteSlut2)
    dölj_utskrifter()
    spara_inte_artikel_nr()
    @sut.run()
  end

end
