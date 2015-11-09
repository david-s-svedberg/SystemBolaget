require_relative 'helpers/artikel_test_helper'

require 'test/unit'
require 'mocha/test_unit'

class GoldenPath < Test::Unit::TestCase
  include ArtikelTestHelper

  def setup()
    @sut = get_sut()
  end

  def test_golden_path()
    default_artikel = skapa_artikel()
    sätt_upp_artiklar(default_artikel)
    filtrera_inte()
    lägg_till_alla_presenterade_artiklar()
    verifiera_valda_artiklar(default_artikel)
    dölj_utskrifter()
    spara_inte_för_tidigare_tilläggningar()
    @sut.run()
  end

end
