require 'csv'
require 'fileutils'
def associa_populacao dir, arquivo_saida, filas_distritos, dados_populacao
  fila = {}
  populacao = {}

  CSV.foreach(filas_distritos) do |row|
    distrito = row[0]
    f = row[1]

    fila[distrito] = f
  end

  CSV.foreach(dados_populacao) do |row|
    distrito = row[0]
    p = row[1]

    populacao[distrito] = p
  end

  #write
 
  CSV.open(dir + arquivo_saida, "wb") do |csv|
    csv << ["Distrito", "Indice per capta (*100)", "Tamanho da fila", "Populacao"]
    i = 1
    fila.each do |k, v|
      csv << [k, (v.to_f / populacao[k].to_f) * 100, v.to_f, populacao[k].to_f] if i!= 1
      i += 1
    end
  end
end
################################################################
#*****************PARA RODAR ESSE ARQUIVO***********************
################################################################
#dir = "/var/www/crecheScraPerData/historico/2015-04-22 12:17"#Diretório onde estão os arquivos
#diretorios = Dir.foreach("/var/www/crecheScraPerData/historico/") do |dir| 
#	associa_populacao "/var/www/crecheScraPerData/historico/" + dir + "/", "filas.csv","/var/www/crecheScraPerData/historico/" + dir + "/agrupado_por_distritos.csv", "/var/www/crecheScraPer/data/populacao_0_4_anos.csv" if dir != "." and dir != ".."
#end
