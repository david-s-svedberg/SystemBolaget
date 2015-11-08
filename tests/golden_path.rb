require_relative 'artikel_test_helper'

require 'nokogiri'
require 'test/unit'
require 'mocha/test_unit'

class GoldenPath < Test::Unit::TestCase
  include ArtikelTestHelper

  def setup()
    @sut = get_sut()
  end

  def test_golden_path()
    sätt_upp_artiklar(skapa_artikel())
    filtrera_inte()
    lägg_till_alla_presenterade_artiklar()
    verifiera_antal_artiklar(1)
    dölj_utskrifter()
    @sut.run()
  end

end
