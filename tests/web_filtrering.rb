require_relative 'artikel_test_helper'

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

end
