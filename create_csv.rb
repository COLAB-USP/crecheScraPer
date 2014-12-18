require_relative 'selenium_creches'
require 'csv'

def scrap_and_save(dir, file_name)
  t = Time.new

  header = ["DRE", "Distrito / Setor", "Faixa Nascimento", "Tamanho da fila"]

  CSV.open(dir + file_name, "wb") do |csv|
    csv << header
    scrap_data_from_website.each do |d|
      csv << d
    end
  end
end
