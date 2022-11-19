require 'product'

class Order
  attr_reader :products

  def initialize(cpf:, product1:, product2:, product3:, discount: 0)
    @products = [product1, product2, product3]
    @cpf = initialize_cpf(cpf)
    @discount = discount
  end

  def total_value
    total = products.map { |product| product.price * product.quantity }.sum
    total - total * @discount / 100
  end

  private

  def initialize_cpf(cpf)
    return cpf if validate_cpf(cpf: cpf)

    raise 'Invalid CPF'
  end

  def validate_cpf(cpf:)
    return false if cpf.nil?
    return false unless cpf.length >= 11 || cpf.length <= 14

    cpf = cpf.gsub(' ', '').gsub('.', '').gsub('-', '').gsub(' ', '')
    return false unless cpf.split('').uniq.size != 1

    begin
      d1 = d2 = 0
      (1...cpf.length - 1).each do |count|
        digito = cpf[count - 1...count].to_i
        d1 += (11 - count) * digito
        d2 += (12 - count) * digito
      end
      rest = d1 % 11
      dg1 = rest < 2 ? 0 : 11 - rest
      d2 += 2 * dg1
      rest = d2 % 11
      dg2 = rest < 2 ? 0 : 11 - rest
      dig_verific = cpf[cpf.length - 2, cpf.length]
      dig_result = "#{dg1}#{dg2}"
      dig_verific == dig_result
    rescue StandardError => e
      puts "Erro: #{e}"
      false
    end
  end
end
