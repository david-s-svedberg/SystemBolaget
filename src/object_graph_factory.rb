require_relative 'system_sök_app'
require_relative 'användar_informerare'
require_relative 'artikel_hämtare'

class ObjectGraphFactory

  def create_app
    return SystemSökApp.new(AnvändarInformerare.new(), ArtikelHämtare.new())
  end

  private

end
