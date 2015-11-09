require_relative '../../src/artikel'
require_relative '../../src/artikel_hämtare'
require_relative '../../src/object_graph_factory'
require_relative '../../src/användar_frågare'
require_relative '../../src/användar_informerare'
require_relative '../../src/valda_artiklar_hållare'
require_relative '../../src/hemsido_hämtare'
require_relative '../../lib/core_ext/string'

module ArtikelTestHelper

  def get_sut()
    return ObjectGraphFactory.new().get_app()
  end

  def skapa_artikel(nr: 1000, artikelId: 1000, namn: 'Artikel namn', namn2: 'Artikel namn 2', pris: 123.45, volym: 330, prisPerLiter: 997.8, säljstart: DateTime.new(2000,1,1), varugrupp: 'Öl', förpackning: 'flaska', ursprungsstad: 'Malmö', ursprungsland: 'Sverige', producent: 'Röstånga Raj Raj', alkoholhalt: '5.00%', sortiment: 'FS', ekologiskt: false, råvarorBeskrivning: 'Råvarubeskrivning')
    return Artikel.new(nr, artikelId, namn, namn2, pris, volym, prisPerLiter, säljstart.to_date.to_datetime, varugrupp, förpackning, ursprungsstad, ursprungsstad, producent, alkoholhalt, sortiment, ekologiskt, råvarorBeskrivning)
  end

  def spara_inte_för_tidigare_tilläggningar()
    ArtikelNrSparare.any_instance.stubs(:spara_tillagd_artikel).returns("")
  end

  def spara_inte_artikel_nr()
    ArtikelNrSparare.any_instance.stubs(:spara_tillagd_artikel).returns("")
    ArtikelNrSparare.any_instance.stubs(:spara_utesluten_artikel).returns("")
    ArtikelNrSparare.any_instance.stubs(:spara_har_kollikrav).returns("")
    ArtikelNrSparare.any_instance.stubs(:spara_saknar_kollikrav).returns("")
    ArtikelNrSparare.any_instance.stubs(:spara_beställningsbar).returns("")
    ArtikelNrSparare.any_instance.stubs(:spara_inte_beställningsbar).returns("")
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
    ValGivare.any_instance.stubs(:visa_uteslutna_artiklar?).returns(true)
    ValGivare.any_instance.stubs(:visa_artiklar_med_kollikrav?).returns(true)
    ValGivare.any_instance.stubs(:visa_artiklar_som_ej_går_att_beställa?).returns(true)
    ValGivare.any_instance.stubs(:visa_artiklar_som_är_tillfälligt_slut?).returns(true)
  end

  def filtrera_varugrupp(*varugrupper)
    filtrera_inte()
    ValGivare.any_instance.stubs(:begränsa_varugrupper?).returns(true)
    ValGivare.any_instance.stubs(:valda_varugrupper).returns(varugrupper)
  end

  def filtrera_sortiment(*sortiment)
    filtrera_inte()
    ValGivare.any_instance.stubs(:begränsa_sortimen?).returns(true)
    ValGivare.any_instance.stubs(:oönskade_sortiment).returns(sortiment)
  end

  def filtrera_säljstart()
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_artiklar_med_framtida_säljstart?).returns(false)
  end

  def filtrera_uteslutna(*uteslutnaArtikelNr)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_uteslutna_artiklar?).returns(false)
    ArtikelNrGivare.any_instance.stubs(:uteslutna_artikel_nr).returns(uteslutnaArtikelNr)
  end

  def filtrera_tidigare_tillagda(*tidigareTillagdaArtikelNr)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_tidigare_tillagda_artiklar?).returns(false)
    ArtikelNrGivare.any_instance.stubs(:tidigare_tillagda_artikel_nr).returns(tidigareTillagdaArtikelNr)
  end

  def filtrera_kollikrav(*artiklarMedKollikrav)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_artiklar_med_kollikrav?).returns(false)
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(any_of(*artiklarMedKollikrav)).returns("asdasd Kollikrav adasd")
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(Not(any_of(*artiklarMedKollikrav))).returns("asdasda")
  end

  def filtrera_cache_kollikrav(*artiklarMedKollikrav)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_artiklar_med_kollikrav?).returns(false)
    ArtikelNrGivare.any_instance.stubs(:artikel_nr_som_visats_ha_kollikrav).returns(artiklarMedKollikrav.map {|artikel| artikel.nr})
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).returns("")
  end

  def filtrera_ej_beställningsbara(*artiklarSomEjÄrBeställningsbara)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_artiklar_som_ej_går_att_beställa?).returns(false)
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(any_of(*artiklarSomEjÄrBeställningsbara)).returns("asdasd Går inte att beställa till övriga butiker adasd")
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(Not(any_of(*artiklarSomEjÄrBeställningsbara))).returns("asdasda")
  end

  def filtrera_ej_beställningsbara_och_tillfälligt_slut(*artiklarSomEjÄrBeställningsbara)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_artiklar_som_ej_går_att_beställa?).returns(false)
    ValGivare.any_instance.stubs(:visa_artiklar_som_är_tillfälligt_slut?).returns(false)
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(any_of(*artiklarSomEjÄrBeställningsbara)).returns("asdasd Går inte att beställa till övriga butiker adasd")
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(Not(any_of(*artiklarSomEjÄrBeställningsbara))).returns("asdasda")
  end

  def filtrera_cache_beställningsbar(*artiklarSomEjÄrBeställningsbara)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_artiklar_som_ej_går_att_beställa?).returns(false)
    ArtikelNrGivare.any_instance.stubs(:artikel_nr_som_visats_vara_icke_beställningsbara).returns(artiklarSomEjÄrBeställningsbara.map {|artikel| artikel.nr})
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).returns("")
  end

  def filtrera_tillfälligt_slut(*artiklarSomÄrTillfälligtSlut)
    filtrera_inte()
    ValGivare.any_instance.stubs(:visa_artiklar_som_är_tillfälligt_slut?).returns(false)
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(any_of(*artiklarSomÄrTillfälligtSlut)).returns("asdasd Tillfälligt slut adasd")
    HemsidoHämtare.any_instance.stubs(:hämta_hemsida).with(Not(any_of(*artiklarSomÄrTillfälligtSlut))).returns("asdasda")
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

  def verifiera_valda_artiklar(*artiklar)
    ValdaArtiklarHållare.any_instance.expects(:lägg_till).times(artiklar.length).with(any_of(*artiklar))
  end

  def verifiera_att_tillfälligt_slut_inte_kontrolleras()
    HemsidoKontrollerare.any_instance.expects(:passerar_tillfälligt_slut_kontroll?).never()
  end

  def kontrollerar_endast_kollikrav_en_gång(artikel)
    tidigareKollikrav = []

    ValGivare.any_instance.stubs(:visa_artiklar_med_kollikrav?).returns(false)
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.expects(:hämta_hemsida).with(artikel).returns("asdasd Kollikrav adasd").once()
    ArtikelNrSparare.any_instance.expects(:spara_har_kollikrav).once().with(){ |artikel|
      tidigareKollikrav << artikel.nr
      true
    }
    ArtikelNrGivare.any_instance.stubs(:artikel_nr_som_visats_ha_kollikrav).returns(tidigareKollikrav)
  end

  def kontrollerar_endast_beställningsbar_en_gång(artikel)
    tidigareIckeBeställningsbar = []

    ValGivare.any_instance.stubs(:visa_artiklar_som_ej_går_att_beställa?).returns(false)
    HemsidoHämtare.any_instance.stubs(:hemsida_finns?).returns(true)
    HemsidoHämtare.any_instance.expects(:hämta_hemsida).with(artikel).returns("asdasd Går inte att beställa till övriga butiker adasd").once()
    ArtikelNrSparare.any_instance.expects(:spara_inte_beställningsbar).once().with(){ |artikel|
      tidigareIckeBeställningsbar << artikel.nr
      true
    }
    ArtikelNrGivare.any_instance.stubs(:artikel_nr_som_visats_vara_icke_beställningsbara).returns(tidigareIckeBeställningsbar)
  end

  def get_artikel_xml(artikel)
    return "<artikel>" \
        "<nr>#{artikel.nr}</nr>" \
        "<Artikelid>#{artikel.artikelid}</Artikelid>" \
        "<Varnummer></Varnummer>" \
        "<Namn>#{artikel.namn}</Namn>" \
        "<Namn2>#{artikel.namn2}</Namn2>" \
        "<Prisinklmoms>#{artikel.pris}</Prisinklmoms>" \
        "<Volymiml>#{artikel.volym}</Volymiml>" \
        "<PrisPerLiter>#{artikel.prisPerLiter}</PrisPerLiter>" \
        "<Saljstart>#{artikel.säljstart.strftime("%Y-%m-%d")}</Saljstart>" \
        "<Slutlev/>" \
        "<Varugrupp>#{artikel.varugrupp}</Varugrupp>" \
        "<Forpackning>#{artikel.förpackning}</Forpackning>" \
        "<Forslutning/>" \
        "<Ursprung>#{artikel.ursprungsstad}</Ursprung>" \
        "<Ursprunglandnamn>#{artikel.ursprungsland}</Ursprunglandnamn>" \
        "<Producent>#{artikel.producent}</Producent>" \
        "<Leverantor></Leverantor>" \
        "<Argang></Argang>" \
        "<Provadargang/>" \
        "<Alkoholhalt>#{artikel.alkoholhalt}</Alkoholhalt>" \
        "<Sortiment>#{artikel.sortiment}</Sortiment>" \
        "<Ekologisk>#{artikel.ekologiskt}</Ekologisk>" \
        "<Koscher></Koscher>" \
        "<RavarorBeskrivning>#{artikel.råvarorBeskrivning}</RavarorBeskrivning>" \
      "</artikel>"
  end
end
