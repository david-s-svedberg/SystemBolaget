require_relative '../helpers/artikel_test_helper'

require 'test/unit'
require 'mocha/test_unit'

class GoldenPath < Test::Unit::TestCase
  include ArtikelTestHelper

  def setup()
    @sut = get_sut()
  end

  def test_golden_path()
    hämta_xml()
    hämta_befintliga_artiklar()
    ta_bort_borttagna_artiklar()
    skapa_nya_artiklar()
    hämtar_info_om_varje_artikel()
    uppdaterar_nya_artiklar()
    spara_artiklar()
  end

end
