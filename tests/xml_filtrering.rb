require_relative 'artikel_test_helper'

require 'test/unit'
require 'mocha/test_unit'

class XmlFiltrering < Test::Unit::TestCase
  include ArtikelTestHelper

  def setup()
    @sut = get_sut()
  end

  def test_filtrerar_varugrupp()
    öl = skapa_artikel(varugrupp: 'Öl')
    vin = skapa_artikel(varugrupp: 'Vin')
    öl2 = skapa_artikel(varugrupp: 'Öl')
    alkoholfritt = skapa_artikel(varugrupp: 'Alkoholfritt')
    sätt_upp_artiklar(öl, vin, öl2, alkoholfritt)
    filtrera_varugrupp('Öl')
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(öl, öl2)
    dölj_utskrifter()
    spara_inte_för_tidigare_tilläggningar()
    @sut.run()
  end

  def test_filtrerar_sortiment()
    bs = skapa_artikel(sortiment: 'BS')
    bs2 = skapa_artikel(sortiment: 'BS')
    annan = skapa_artikel(sortiment: 'TS')
    annan2 = skapa_artikel(sortiment: 'TLSL')
    sätt_upp_artiklar(bs, bs2, annan, annan2)
    filtrera_sortiment('BS')
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(annan, annan2)
    dölj_utskrifter()
    spara_inte_för_tidigare_tilläggningar()
    @sut.run()
  end

  def test_filtrerar_framtida_säljstart()
    gammal = skapa_artikel(säljstart: DateTime.new(2001,1,1))
    sammaDag = skapa_artikel(säljstart: DateTime.now)
    senare = skapa_artikel(säljstart: (Date.today + 5).to_datetime)
    senare2 = skapa_artikel(säljstart: (Date.today + 10).to_datetime)
    sätt_upp_artiklar(gammal, sammaDag, senare, senare2)
    filtrera_säljstart()
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(gammal, sammaDag)
    dölj_utskrifter()
    spara_inte_för_tidigare_tilläggningar()
    @sut.run()
  end

  def test_filtrerar_uteslutna()
    utesluten = skapa_artikel(nr: 1)
    utesluten2 = skapa_artikel(nr: 2)
    inteUtesluten = skapa_artikel(nr: 3)
    inteUtesluten2 = skapa_artikel(nr: 4)
    sätt_upp_artiklar(utesluten, utesluten2, inteUtesluten, inteUtesluten2)
    filtrera_uteslutna(1,2)
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(inteUtesluten, inteUtesluten2)
    dölj_utskrifter()
    spara_inte_för_tidigare_tilläggningar()
    @sut.run()
  end

  def test_filtrerar_tidigare_tillagda()
    tillagd = skapa_artikel(nr: 1)
    tillagd2 = skapa_artikel(nr: 2)
    inteTillagd = skapa_artikel(nr: 3)
    inteTillagd2 = skapa_artikel(nr: 4)
    sätt_upp_artiklar(tillagd, tillagd2, inteTillagd, inteTillagd2)
    filtrera_tidigare_tillagda(1,2)
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(inteTillagd, inteTillagd2)
    dölj_utskrifter()
    spara_inte_för_tidigare_tilläggningar()
    @sut.run()
  end

end
