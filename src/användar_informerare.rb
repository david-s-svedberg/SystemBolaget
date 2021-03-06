class AnvändarInformerare

  def hämtar_artiklar()
    clear_console()
    puts("Hämtar artiklar...")
  end

  def artiklar_hämtade()
    clear_console()
    puts("Artiklar hämtade!")
  end

  def hemsida_finns_inte(url)
    puts("Websidan finns inte: #{url}")
  end

  def filtrerar(antalBortfiltrerare)
    clear_console()
    puts("Filtrerar... (#{antalBortfiltrerare} bortfiltrerare)")
  end

  def val_för_visad_artikel()
    puts("Välj mellan: [L]ägg till, [S]kippa, [U]teslut, [Ö]ppna hemsida eller [A]vbryt.")
  end

  def val_för_felaktig_hemsida()
    puts("Välj mellan: [V]isa artikel, [S]kippa, [U]teslut eller [A]vbryt.")
  end

  def clear_console()
    puts "\e[H\e[2J"
  end

end
