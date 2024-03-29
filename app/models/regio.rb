class Regio
  RegioOption = Struct.new(:id, :name)
  class RegioType
    attr_reader :type_name, :options

    def initialize(name)
      @type_name = name
      @options = []
    end

    def <<(option)
      @options << option
    end
  end

  REGIO = []

  algemeen = RegioType.new("Algemeen")
  REGIO[002] = "onbekend"
  algemeen << RegioOption.new(002, "Regio onbekend")
  REGIO[000] = "Gans Vlaanderen"
  algemeen << RegioOption.new(000, "Gans Vlaanderen")
  REGIO[001] = "Standaard Nederlands"
  algemeen << RegioOption.new(001, "Standaard Nederlands")

  provincies = RegioType.new("Provincies")
  REGIO[100] = "West-Vlaanderen"
  provincies << RegioOption.new(100, "West-Vlaanderen")
  REGIO[200] = "Oost-Vlaanderen"
  provincies << RegioOption.new(200, "Oost-Vlaanderen")
  REGIO[300] = "Antwerpen"
  provincies << RegioOption.new(300, "Antwerpen")
  REGIO[400] = "Vlaams Brabant"
  provincies << RegioOption.new(400, "Vlaams Brabant")
  REGIO[500] = "Limburg"
  provincies << RegioOption.new(500, "Limburg")

  wvregios = RegioType.new("West-Vlaamse regio's")
  REGIO[110] = "Vlaamse Kust"
  wvregios << RegioOption.new(110, "Vlaamse Kust")
  REGIO[120] = "Westhoek"
  wvregios << RegioOption.new(120, "Westhoek")
  REGIO[130] = "Brugge"
  wvregios << RegioOption.new(130, "Brugge")
  REGIO[140] = "Brugs Ommeland"
  wvregios << RegioOption.new(140, "Brugs Ommeland")
  REGIO[150] = "Leiestreek"
  wvregios << RegioOption.new(150, "Leiestreek")

  ovregios = RegioType.new("Oost-Vlaamse regio's")
  REGIO[210] = "Meetjesland"
  ovregios << RegioOption.new(210, "Meetjesland")
  REGIO[220] = "Gent"
  ovregios << RegioOption.new(220, "Gent")
  REGIO[230] = "Vlaamse Ardennen"
  ovregios << RegioOption.new(230, "Vlaamse Ardennen")
  REGIO[240] = "Waasland"
  ovregios << RegioOption.new(240, "Waasland")
  REGIO[250] = "Scheldeland"
  ovregios << RegioOption.new(250, "Scheldeland")

  anregios = RegioType.new("Antwerpse regio's")
  REGIO[310] = "Antwerpen"
  anregios << RegioOption.new(310, "Antwerpen")
  REGIO[320] = "Mechelen"
  anregios << RegioOption.new(320, "Mechelen")
  REGIO[330] = "Antwerpse Kempen"
  anregios << RegioOption.new(330, "Antwerpse Kempen")

  vbregios = RegioType.new("Vlaams-Brabantse regio's")
  REGIO[410] = "Brussel"
  vbregios << RegioOption.new(410, "Brussel")
  REGIO[420] = "Groene Gordel"
  vbregios << RegioOption.new(420, "Groene Gordel")
  REGIO[430] = "Leuven"
  vbregios << RegioOption.new(430, "Leuven")
  REGIO[440] = "Hageland"
  vbregios << RegioOption.new(440, "Hageland")

  liregios = RegioType.new("Limburgse regio's")
  REGIO[510] = "Limburgse Kempen"
  liregios << RegioOption.new(510, "Limburgse Kempen")
  REGIO[520] = "Mijnstreek"
  liregios << RegioOption.new(520, "Mijnstreek")
  REGIO[530] = "Haspengouw"
  liregios << RegioOption.new(530, "Haspengouw")
  REGIO[540] = "Maasland"
  liregios << RegioOption.new(540, "Maasland")
  REGIO[550] = "Voerstreek"
  liregios << RegioOption.new(550, "Voerstreek")

  OPTIONS = [algemeen, provincies, wvregios, ovregios, anregios, vbregios, liregios]
end
