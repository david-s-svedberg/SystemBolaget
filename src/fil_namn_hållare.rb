class FilNamnHållare
  RUNNING_FOLDER = File.dirname(__FILE__)
  BIN_PATH = File.join(RUNNING_FOLDER, "../bin")
  TIDIGARE_TILLAGDA = File.join(BIN_PATH, "tidigare_tillagda.dat")
  UTESLUTNA = File.join(BIN_PATH, "uteslutna.dat")
  KOLLIKRAV = File.join(BIN_PATH, "kollikrav.dat")
  KOLLIKRAV_SAKNAS = File.join(BIN_PATH, "kollikrav_saknas.dat")
  BESTÄLLNINGSBARA = File.join(BIN_PATH, "beställningsbara.dat")
  INTE_BESTÄLLNINGSBARA = File.join(BIN_PATH, "inte_beställningsbara.dat")
end
