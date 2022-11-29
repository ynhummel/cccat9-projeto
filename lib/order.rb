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

    parsed_cpf = cpf.gsub(/\D/, '').split('')
    return false if invalid_length?(cpf: parsed_cpf)
    return false if all_digits_equal?(cpf: parsed_cpf)

    dig_result1 = digit_calculation(cpf: parsed_cpf, factor: 10)
    dig_result2 = digit_calculation(cpf: parsed_cpf, factor: 11)
    actual_digits = extract_digits(cpf: parsed_cpf)
    calculated_digits = "#{dig_result1}#{dig_result2}"
    actual_digits == calculated_digits
  end

  def extract_digits(cpf:)
    cpf[-2..].join
  end

  def invalid_length?(cpf:)
    cpf.length != 11
  end

  def all_digits_equal?(cpf:)
    cpf.uniq.size == 1
  end

  def digit_calculation(cpf:, factor:)
    total = 0
    cpf.each do |digit|
      if factor > 1
        total += digit.to_i * factor
        factor -= 1
      end
    end
    rest = total % 11
    rest < 2 ? 0 : 11 - rest
  end
end
