require_relative 'distritos_setores'
require 'csv'

def agrupa_por_distrito(dir, file_name, csv_file)
  lines = []

  CSV.foreach(csv_file) do |csv|
    lines << csv
  end
  #remove cabecalho
  lines.delete_at 0

  #process
  i = 1
  filas = {}
  lines.each do |line|

     if(i <= 3)
       distrito = line[1].slice(0..(line[1].index('/') - 2))
       fila = line[3].to_i
       filas[distrito] = filas[distrito].nil? ? fila : filas[distrito].to_i + fila
     end

    if i < 6
      i+=1
    else
      i = 1
    end
  end
  #write
  CSV.open(dir + file_name, "wb") do |csv|
    csv << ["Distrito", "Tamanho da fila"]
    filas.each do |dist, fila|
      csv << [dist, fila]
    end
  end
end

################################################################
#*****************PARA RODAR ESSE ARQUIVO***********************
################################################################

dir = "/var/www/html/cuidando2/creches/Site/scripts/2014-12-18 12:50/"#Diretório onde estão os arquivos
agrupa_por_distrito dir, "agrupado_por_distritos.csv", dir + "scrap.csv"
