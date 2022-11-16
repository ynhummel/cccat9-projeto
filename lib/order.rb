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
    return cpf if validate_cpf(str: cpf)

    raise 'Invalid CPF'
  end

  def validate_cpf(str:)
    if !str.nil?
      if str.length >= 11 || str.length <= 14
        str = str.gsub(' ', '').gsub('.', '').gsub('-', '').gsub(' ', '')
        if str.split('').uniq.size != 1
          begin
            d1 = d2 = dg1 = dg2 = rest = 0
            (1...str.length - 1).each do |count|
              digito = str[count - 1...count].to_i
              d1 = d1 + (11 - count) * digito
              d2 = d2 + (12 - count) * digito
            end
            rest = d1 % 11
            dg1 = rest < 2 ? 0 : 11 - rest
            d2 += 2 * dg1
            rest = d2 % 11
            if rest < 2
              dg2 = 0
            else
              dg2 = 11 - rest
            end
            dig_verific = str[str.length - 2, str.length]
            dig_result = '' + dg1.to_s + '' + dg2.to_s
            dig_verific == dig_result
          rescue StandardError => e
            puts "Erro: #{e}"
            false
          end
        else
          false
        end
      else
        false
      end
    else
      false
    end
  end
end
