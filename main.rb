# encoding: utf-8

#cria diretorio com data/hora
require 'fileutils'
require_relative 'config'
t = Time.new
dir = "#{directory}/#{t.year}-#{ t.month <= 9 ? '0' + t.month.to_s : t.month }-#{ t.day <= 9 ? '0' + t.day.to_s : t.day  } #{ t.hour <= 9 ? '0' + t.hour.to_s : t.hour }:#{ t.min <= 9 ? '0' + t.min.to_s : t.min }/"
FileUtils::mkdir_p dir

#1 ler dados
require_relative 'create_csv'
scrap_and_save dir, "scrap.csv"

#2 agrupar por distrito
require_relative 'agrupamento'
agrupa_por_distrito dir, "agrupado_por_distritos.csv", dir + "scrap.csv"

#3 associar com dados da SEADE
require_relative 'associacao_populacao_seade'
associa_populacao dir, "fila.csv", dir + "agrupado_por_distritos.csv", "data/populacao_0_4_anos.csv"

#4 atualiza arquivo no diretorio do Site
#FileUtils::rm "#{Dir.pwd}/filas.csv", :force => true
#FileUtils::cp file_final, @dir_data
