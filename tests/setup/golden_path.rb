require_relative '../helpers/artikel_test_helper'

require 'test/unit'
require 'mocha/test_unit'

class GoldenPath < Test::Unit::TestCase
  include ArtikelTestHelper

  def setup()
    @sut = get_sut()
  end

end
