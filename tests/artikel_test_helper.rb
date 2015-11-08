require_relative '../src/artikel'
require_relative '../src/artikel_hämtare'
require_relative '../src/object_graph_factory'
require_relative '../src/användar_frågare'
require_relative '../src/användar_informerare'
require_relative '../src/valda_artiklar_hållare'
require_relative '../lib/core_ext/string'

module ArtikelTestHelper

  def get_sut()
    return ObjectGraphFactory.new().get_app()
  end

  def skapa_artikel(nr: 1000, artikelId: 1000, namn: 'Artikel namn', namn2: 'Artikel namn 2', pris: 123.45, volym: 330, prisPerLiter: 997.8, säljstart: DateTime.new(2000,1,1), varugrupp: 'Öl', förpackning: 'flaska', ursprungsstad: 'Malmö', ursprungsland: 'Sverige', producent: 'Röstånga Raj Raj', alkoholhalt: '5.00%', sortiment: 'FS', ekologiskt: false, råvarorBeskrivning: 'Råvarubeskrivning')
    return Artikel.new(nr, artikelId, namn, namn2, pris, volym, prisPerLiter, säljstart, varugrupp, förpackning, ursprungsstad, ursprungsstad, producent, alkoholhalt, sortiment, ekologiskt, råvarorBeskrivning)
  end

  def dölj_utskrifter()
    AnvändarInformerare.any_instance.stubs(:hämtar_artiklar).returns("")
    AnvändarInformerare.any_instance.stubs(:artiklar_hämtade).returns("")
    AnvändarInformerare.any_instance.stubs(:hemsida_finns_inte).returns("")
    AnvändarInformerare.any_instance.stubs(:filtrerar).returns("")
    AnvändarInformerare.any_instance.stubs(:val_för_visad_artikel).returns("")
    AnvändarInformerare.any_instance.stubs(:val_för_felaktig_hemsida).returns("")
    AnvändarInformerare.any_instance.stubs(:clear_console).returns("")
    ArtikelPresenterare.any_instance.stubs(:visa_artikel).returns("")
  end

  def filtrera_inte()
    ValGivare.any_instance.stubs(:begränsa_varugrupper?).returns(false)
    ValGivare.any_instance.stubs(:begränsa_sortimen?).returns(false)
    ValGivare.any_instance.stubs(:visa_artiklar_med_framtida_säljstart?).returns(true)
    ValGivare.any_instance.stubs(:visa_tidigare_tillagda_artiklar?).returns(true)
    ValGivare.any_instance.stubs(:visa_artiklar_med_kollikrav?).returns(true)
    ValGivare.any_instance.stubs(:visa_artiklar_som_ej_går_att_beställa?).returns(true)
    ValGivare.any_instance.stubs(:visa_artiklar_som_är_tillfälligt_slut?).returns(true)
  end

  def sätt_upp_artiklar(*artiklar)
    artikelArray = []
    artiklar.each do |artikel|
      artikelArray << get_artikel_xml(artikel)
    end
    xml = artikelArray.join("\n").wrap("<artiklar>", "</artiklar>")

    XMLHämtare.any_instance.stubs(:hämta_xml).returns(xml)
  end

  def lägg_till_alla_presenterade_artiklar()
    AnvändarFrågare.any_instance.stubs(:begär_val_för_visad_artikel).returns('l')
  end

  def verifiera_antal_artiklar(nbrOfTimes)
    ValdaArtiklarHållare.any_instance.expects(:lägg_till).with(any_parameters()).times(nbrOfTimes)
  end

  def get_artikel_xml(artikel)
    return "<artikel>" \
        "<nr>#{artikel.nr}</nr>" \
        "<Artikelid></Artikelid>" \
        "<Varnummer></Varnummer>" \
        "<Namn>#{artikel.namn}</Namn>" \
        "<Namn2>#{artikel.namn2}</Namn2>" \
        "<Prisinklmoms>#{artikel.pris}</Prisinklmoms>" \
        "<Volymiml>#{artikel.volym}</Volymiml>" \
        "<PrisPerLiter>#{artikel.prisPerLiter}</PrisPerLiter>" \
        "<Saljstart>#{artikel.säljstart.strftime("%Y-%m-%d")}</Saljstart>" \
        "<Slutlev/>" \
        "<Varugrupp>#{artikel.varugrupp}</Varugrupp>" \
        "<Forpackning></Forpackning>" \
        "<Forslutning/>" \
        "<Ursprung></Ursprung>" \
        "<Ursprunglandnamn></Ursprunglandnamn>" \
        "<Producent></Producent>" \
        "<Leverantor></Leverantor>" \
        "<Argang></Argang>" \
        "<Provadargang/>" \
        "<Alkoholhalt>#{artikel.alkoholhalt}</Alkoholhalt>" \
        "<Sortiment>#{artikel.sortiment}</Sortiment>" \
        "<Ekologisk></Ekologisk>" \
        "<Koscher></Koscher>" \
      "</artikel>"
  end
end
