require_relative 'distritos_setores'
require "selenium-webdriver"

def scrap_data_from_website
  data = []
  @driver = Selenium::WebDriver.for :firefox
  @driver.navigate.to "http://eolgerenciamento.prefeitura.sp.gov.br/se1426g/frmgerencial/ConsultaCandidatosCadastrados.aspx?Cod=000000"

  n_diretorias = 13
  n_faixas_etarias = 6
  diretorias_regionais = @driver.find_element(:id, "cboDRE").text.split("\n")
  faixas_etarias = @driver.find_element(:id, "cboFaixaEtaria").text.split("\n")
  erros = []

  (1..n_diretorias).each do |dre|
    selecione_diretoria_regional(dre)
    setores(dre).each do |s|
      selecione_setor s
      (1..n_faixas_etarias).each do |faixa_etaria|
        begin
          selecione_faixa_etaria faixa_etaria
          clique_confirmar
          fila = tamanho_da_fila
          data << [diretorias_regionais[dre], s, faixas_etarias[faixa_etaria], fila]
        rescue  Exception => e
          erros << [dre, s, faixa_etaria, e]
        end
      end
    end
  end

  @driver.quit
  return data
end

def selecione_diretoria_regional dre
  Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "cboDRE")).select_by(:index, dre)
end

def selecione_setor setor
  Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "cboSetor")).select_by(:text, setor)
end

def selecione_faixa_etaria faixa_etaria
  Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "cboFaixaEtaria")).select_by(:index, faixa_etaria)
end

def clique_confirmar
  @driver.find_element(:id, "btnConfirmar").click
end

def tamanho_da_fila
  fila = 0
  begin
    fila = @driver.find_element(:class, "gerencialRelatTexto1").text
    fila["Total de candidatos com os Parâmetros Informados = "] = ""
  rescue
  end
  fila
end
