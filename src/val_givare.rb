require 'optparse'

class ValGivare

  def initialize()

    #DEFAULTS
    @visaFramtidaSäljstart = false
    @visaTidigareTillagda = false
    @visaUteslutna = false
    @visaArtiklarMedKollikrav = false
    @visaArtiklarSomEjGårAttBeställa = false
    @visaArtiklarSomÄrTillfälligtSlut = false
    @visaArtiklarSomHarUtgått = false
    @begränsaPris = false
    @oönskadeSortiment = []
    @varugrupper = []
    @typer = []

    OptionParser.new do |opts|
      opts.banner = "Usage: main.rb [options]"

      opts.on('-ss', '--säljstart', 'Visa artiklar med framtida säljstart') { @visaFramtidaSäljstart = true }
      opts.on('-ut', '--utesluttillagda', 'Visa ej artiklar som lagts till tidigare') { @visaTidigareTillagda = true }
      opts.on('-uu', '--uteslututeslutna', 'Visa ej artiklar som uteslutits') { @visaUteslutna = true }
      opts.on('-kk', '--kollikrav', 'Visa artiklar som har ett kollikrav ') { @visaArtiklarMedKollikrav = true }
      opts.on('-eb', '--ejbeställlbara', 'Visa artiklar som ej går att beställa då de bara får säljas till ett systembolag ') { @visaArtiklarSomEjGårAttBeställa = true }
      opts.on('-ug', '--utgått', 'Visa artiklar som har utgått') { @visaArtiklarSomHarUtgått = true }
      opts.on('-ts', '--tillfälligtslut', 'Visa artiklar som är tillfälligt slut') { @visaArtiklarSomÄrTillfälligtSlut = true }
      opts.on('-p', '--maxpris PRIS', 'Visa endast artiklar med ett ptris lägre än PRIS') { |maxPris| @begränsaPris = true ; @maxPris = maxPris}
      opts.on('--oönskadeSortiment x,y,y', Array, 'Lista av sortiment som inte är önskvärda') { |oönskadeSortiment| @oönskadeSortiment = oönskadeSortiment }
      opts.on('--varugrupper x,y,y', Array, 'Lista av varugrupper som ska visas') { |varugrupper| @varugrupper = varugrupper }
      opts.on('--typer x,y,y', Array, 'Lista av dryckestyper som ska visas') { |typer| @typer = typer }

    end.parse!

  end

  def begränsa_varugrupper?()
    return !@varugrupper.empty?
  end

  def valda_varugrupper()
    return @varugrupper
  end

  def begränsa_typer?()
    return !@typer.empty?
  end

  def valda_typer()
    return @typer
  end

  def begränsa_sortimen?()
    return !@oönskadeSortiment.empty?
  end

  def oönskade_sortiment()
    return @oönskadeSortiment
  end

  def visa_artiklar_med_framtida_säljstart?()
    return @visaArtiklarMedFramtidaSäljstart
  end

  def visa_tidigare_tillagda_artiklar?()
    return @visaTidigaTillagda
  end

  def visa_uteslutna_artiklar?()
    return @visaUteslutna
  end

  def visa_artiklar_med_kollikrav?()
    return @visaArtiklarMedKollikrav
  end

  def visa_artiklar_som_ej_går_att_beställa?()
    return @visaArtiklarSomEjGårAttBeställa
  end

  def visa_artiklar_som_är_tillfälligt_slut?()
    return @visaArtiklarSomÄrTillfälligtSlut
  end

  def visa_artiklar_som_har_utgått?()
    return @visaArtiklarSomHarUtgått
  end

  def begränsa_pris?()
    return @begränsaPris
  end

  def max_pris
    return @maxPris
  end

end
