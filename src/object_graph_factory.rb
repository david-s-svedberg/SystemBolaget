require_relative 'användar_frågare'
require_relative 'användar_informerare'
require_relative 'artikel_factory'
require_relative 'artikel_filtrerare'
require_relative 'artikel_hämtare'
require_relative 'artikel_hemsido_visare'
require_relative 'artikel_nr_givare'
require_relative 'artikel_nr_sparare'
require_relative 'artikel_presenterare'
require_relative 'datum_givare'
require_relative 'fil_namn_hållare'
require_relative 'hemsido_kontrollerare'
require_relative 'system_sök_app'
require_relative 'val_givare'
require_relative 'valda_artiklar_hållare'
require_relative 'website_url_generator'
require_relative 'xml_hämtare'
require_relative 'xpath_query_generator'

class ObjectGraphFactory

  def initialize()
    @app = nil
    @användarInformerare = nil
    @artikelHämtare = nil
    @xmlHämtare = nil
    @xpathQueryGenerator = nil
    @valGivare = nil
    @datumGivare = nil
    @artikelNrGivare = nil
    @artikelFactory = nil
    @artikelPresenterare = nil
    @artikelFiltrerare = nil
    @hemsidoKontrollerare = nil
    @användarFrågare = nil
    @websiteURLGenerator = nil
    @artikelNrSparare = nil
    @artikelHemsidoVisare = nil
    @valdaArtikelHållare = nil
    @hemsidoHämtare = nil
  end

  def get_app()
    @app = create_app() unless @app != nil
    return @app
  end

  def get_artikel_presenterare()
    @artikelPresenterare = create_artikel_presenterare() unless @artikelPresenterare != nil
    return @artikelPresenterare
  end

  def get_xpath_query_generator()
    @xpathQueryGenerator = create_xpath_query_generator() unless @xpathQueryGenerator != nil
    return @xpathQueryGenerator
  end

  def get_valda_artiklar_hållare()
    @valdaArtikelHållare = create_valda_artiklar_hållare() unless @valdaArtikelHållare != nil
    return @valdaArtikelHållare
  end

  def get_datum_givare()
    @datumGivare = DatumGivare.new() unless @datumGivare != nil
    return @datumGivare
  end

  def get_artikel_factory()
    @artikelFactory = ArtikelFactory.new() unless @artikelFactory != nil
    return @artikelFactory
  end

  def get_användar_informerare()
    @användarInformerare = AnvändarInformerare.new() unless @användarInformerare != nil
    return @användarInformerare
  end

  def get_val_givare()
    @valGivare = ValGivare.new() unless @valGivare != nil
    return @valGivare
  end

  def get_artikel_nr_givare()
    @artikelNrGivare = ArtikelNrGivare.new() unless @artikelNrGivare != nil
    return @artikelNrGivare
  end

  def get_användar_frågare()
    @användarFrågare = AnvändarFrågare.new() unless @användarFrågare != nil
    return @användarFrågare
  end

  def get_website_url_generator()
    @websiteURLGenerator = WebsiteURLGenerator.new() unless @websiteURLGenerator != nil
    return @websiteURLGenerator
  end

  def get_artikel_nr_sparare()
    @artikelNrSparare = ArtikelNrSparare.new() unless @artikelNrSparare != nil
    return @artikelNrSparare
  end

  def get_artikel_hemsido_visare()
    @artikelHemsidoVisare = create_artikel_hemsido_visare() unless @artikelHemsidoVisare != nil
    return @artikelHemsidoVisare
  end


  def get_artikel_filtrerare()
    @artikelFiltrerare = create_artikel_filtrerare() unless @artikelFiltrerare != nil
    return @artikelFiltrerare
  end

  def get_hemsido_kontrollerare()
    @hemsidoKontrollerare = create_hemsido_kontrollerare() unless @hemsidoKontrollerare != nil
    return @hemsidoKontrollerare
  end

  def get_artikel_hämtare()
    @artikelHämtare = create_artikel_hämtare() unless @artikelHämtare != nil
    return @artikelHämtare
  end

  def get_xml_hämtare()
    @xmlHämtare = create_xml_hämtare() unless @xmlHämtare != nil
    return @xmlHämtare
  end

  def get_hemsido_hämtare()
    @hemsidoHämtare = create_hemsido_hämtare() unless @hemsidoHämtare != nil
    return @hemsidoHämtare
  end

  private

    def create_app()
      return SystemSökApp.new( \
        get_användar_informerare(), \
        get_artikel_hämtare(), \
        get_artikel_presenterare() \
      )
    end

    def create_artikel_presenterare()
      return ArtikelPresenterare.new( \
        get_användar_informerare(), \
        get_artikel_filtrerare(), \
        get_användar_frågare(), \
        get_artikel_hemsido_visare(), \
        get_artikel_nr_sparare(), \
        get_valda_artiklar_hållare()
      )
    end

    def create_valda_artiklar_hållare()
      return ValdaArtiklarHållare.new()
    end


    def create_artikel_hemsido_visare()
      return ArtikelHemsidoVisare.new( \
          get_website_url_generator() \
        )
    end

    def create_artikel_filtrerare()
      return ArtikelFiltrerare.new( \
        get_val_givare(), \
        get_hemsido_kontrollerare() \
      )
    end

    def create_hemsido_kontrollerare()
      return HemsidoKontrollerare.new( \
          get_val_givare(), \
          get_hemsido_hämtare(), \
          get_användar_informerare(), \
          get_användar_frågare(), \
          get_artikel_nr_sparare(), \
          get_artikel_nr_givare() \
        )
    end

    def create_artikel_hämtare()
      return ArtikelHämtare.new( \
        get_xml_hämtare(), \
        get_xpath_query_generator(), \
        get_artikel_factory() \
      )
    end

    def create_hemsido_hämtare()
      return HemsidoHämtare.new(get_website_url_generator())
    end

    def create_xml_hämtare()
      return XMLHämtare.new("http://www.systembolaget.se/api/assortment/products/xml")
    end

    def create_xpath_query_generator()
      return XpathQueryGenerator.new( \
          get_val_givare(), \
          get_datum_givare(), \
          get_artikel_nr_givare() \
        )
    end

end
