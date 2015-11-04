class SystemSökApp

  def initialize(användarInformerare, artikelHämtare, artikelPresenterare)
    @användarInformerare = användarInformerare
    @artikelHämtare = artikelHämtare
    @artikelPresenterare = artikelPresenterare
  end

  def run
    @användarInformerare.hämtar_artiklar()
    artiklar = @artikelHämtare.hämta_artiklar()
    @användarInformerare.artiklar_hämtade()
    @artikelPresenterare.presentera_artiklar(artiklar)
  end

end
