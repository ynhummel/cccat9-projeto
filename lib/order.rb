require_relative './product'

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

    cpf = cpf.gsub(/[ .-]/, '')
    return false unless cpf.split('').uniq.size != 1

    begin
      dig_result1 = dig_result2 = 0
      cpf[0..9]
      (1...cpf.length - 1).each do |count|
        digito = cpf[count - 1...count].to_i
        dig_result1 += (11 - count) * digito
        dig_result2 += (12 - count) * digito
      end
      rest = dig_result1 % 11
      dig_result1 = rest < 2 ? 0 : 11 - rest
      dig_result2 += 2 * dig_result1
      rest = dig_result2 % 11
      dig_result2 = rest < 2 ? 0 : 11 - rest
      dig_verific = cpf[cpf.length - 2, cpf.length]
      dig_result = "#{dig_result1}#{dig_result2}"
      dig_verific == dig_result
    rescue StandardError => e
      puts "Erro: #{e}"
      false
    end
  end
end
