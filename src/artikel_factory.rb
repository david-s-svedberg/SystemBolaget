require_relative('artikel')

class ArtikelFactory

  def skapa_artiklar_från_noder(noder)
    artiklar = []
    noder.each do |nod|
      artiklar << skapa_artikel(nod)
    end
    return artiklar
  end

  private

    def skapa_artikel(node)
      nr = node.get_childnode_text('nr').to_i
      artikelId = node.get_childnode_text('Artikelid').to_i
      namn = node.get_childnode_text('Namn')
      namn2 = node.get_childnode_text('Namn2')
      pris = node.get_childnode_text('Prisinklmoms').to_f
      volym = node.get_childnode_text('Volymiml').to_f
      prisPerLiter = node.get_childnode_text('PrisPerLiter').to_f
      säljstart = DateTime.strptime(node.get_childnode_text('Saljstart'), '%Y-%m-%d')
      varugrupp = node.get_childnode_text('Varugrupp')
      förpackning = node.get_childnode_text('Forpackning')
      ursprungsstad = node.get_childnode_text('Ursprung')
      ursprungsland = node.get_childnode_text('Ursprunglandnamn')
      producent = node.get_childnode_text('Producent')
      alkoholhalt = node.get_childnode_text('Alkoholhalt')
      sortiment = node.get_childnode_text('Sortiment')
      ekologiskt = !node.get_childnode_text('Ekologisk').to_i.zero?
      råvarorBeskrivning = node.get_childnode_text('RavarorBeskrivning')
      return Artikel.new(nr, artikelId, namn, namn2, pris, volym, prisPerLiter, säljstart, varugrupp, förpackning, ursprungsstad, ursprungsstad, producent, alkoholhalt, sortiment, ekologiskt, råvarorBeskrivning)
    end

end
