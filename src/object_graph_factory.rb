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
require_relative 'website_url_generator'
require_relative 'xml_hämtare'
require_relative 'xpath_query_generator'


class ObjectGraphFactory

  def initialize()
    @användarInformerare = nil
    @valGivare = nil
    @artikelNrGivare = nil
    @filNamnHållare = nil
    @användarFrågare = nil
    @websiteURLGenerator = nil
    @artikelNrSparare = nil
  end

  def create_app()
    return SystemSökApp.new( \
            get_användar_informerare(), \
            ArtikelHämtare.new( \
              XMLHämtare.new("http://www.systembolaget.se/api/assortment/products/xml"), \
              XpathQueryGenerator.new( \
                get_val_givare(), \
                DatumGivare.new(), \
                get_artikel_nr_givare() \
              ), \
              ArtikelFactory.new()
            ), \
            ArtikelPresenterare.new( \
              get_användar_informerare(), \
              ArtikelFiltrerare.new( \
                get_val_givare(), \
                get_artikel_nr_givare(), \
                HemsidoKontrollerare.new( \
                  get_website_url_generator(), \
                  get_användar_informerare(), \
                  get_användar_frågare(), \
                  get_artikel_nr_sparare() \
                ) \
              ), \
              get_användar_frågare(), \
              ArtikelHemsidoVisare.new( \
                get_website_url_generator() \
              ), \
              get_artikel_nr_sparare() \
            ) \
          )
  end

  private

    def get_användar_informerare()
      @användarInformerare = AnvändarInformerare.new() unless @användarInformerare != nil
      return @användarInformerare
    end

    def get_val_givare()
      @valGivare = ValGivare.new() unless @valgivare != nil
      return @valgivare
    end

    def get_artikel_nr_givare()
      @artikelNrGivare = ArtikelNrGivare.new(get_filnamn_hållare()) unless @artikelNrGivare != nil
      return @artikelNrGivare
    end

    def get_filnamn_hållare()
      @filNamnHållare = FilNamnHållare.new() unless @filNamnHållare != nil
      return @filNamnHållare
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
      @artikelNrSparare = ArtikelNrSparare.new(get_filnamn_hållare()) unless @artikelNrSparare != nil
      return @artikelNrSparare
    end

end
