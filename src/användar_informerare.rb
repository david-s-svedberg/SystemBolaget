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

  def filtrerar()
    clear_console()
    puts("Filtrerar...")
  end

  def hittat_artikel()
    clear_console()
    puts("Har hittat artikel!")
  end

  private
    def clear_console()
      puts "\e[H\e[2J"
    end

end
