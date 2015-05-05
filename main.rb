# encoding: utf-8

#cria diretorio com data/hora
require 'fileutils'
require_relative 'config'

t = Time.new
dir = "#{directory}#{t.year}-#{ t.month <= 9 ? '0' + t.month.to_s : t.month }-#{ t.day <= 9 ? '0' + t.day.to_s : t.day  } #{ t.hour <= 9 ? '0' + t.hour.to_s : t.hour }:#{ t.min <= 9 ? '0' + t.min.to_s : t.min }/"
puts dir
FileUtils::mkdir_p dir
File.open("#{directory}log.txt", 'a') do |file|
file << "***********NOVO ARQUIVO*************\n"
file << dir + "\n"
#1 ler dadoS

file << "#1 ler dados\n"
begin
require_relative 'create_csv'
scrap_and_save dir, "scrap.csv"

file << "#2 agrupar por distrito\n"
#2 agrupar por distrito
require_relative 'agrupamento'
agrupa_por_distrito dir, "agrupado_por_distritos.csv", dir + "scrap.csv"

file << "#3 associar com dados da SEADE\n"
#3 associar com dados da SEADE
require_relative 'associacao_populacao_seade'
associa_populacao dir, "filas.csv", dir + "agrupado_por_distritos.csv", "#{dir_data}populacao_0_4_anos.csv"

file << "#4 atualiza arquivo no diretorio do Site\n"
##4 atualiza arquivo no diretorio do Site

FileUtils::rm "#{diretorio_site}/filas.csv", :force => true
FileUtils::cp dir + "filas.csv", diretorio_site
rescue => e
 file << "********ERROR***********\n"
 file <<  e.backtrace.join("\n")
end

end
