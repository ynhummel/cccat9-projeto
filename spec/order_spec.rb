# order_spec.rb
require 'spec_helper'
require 'order'

describe Order do
  context 'Must create an Order' do
    before(:each) do
      @caneta = Product.new(description: 'Caneta', price: 10, quantity: 3)
      @caderno = Product.new(description: 'Caderno', price: 20, quantity: 2)
      @borracha = Product.new(description: 'Borracha', price: 5, quantity: 1)
    end

    it 'with exactly 3 products' do
      order = Order.new(cpf: '813.841.100-70',
                        product1: @caneta,
                        product2: @caderno,
                        product3: @borracha)

      expect(order.products.size).to eq(3)
    end

    it 'and compute the total order value' do
      order = Order.new(cpf: '813.841.100-70',
                        product1: @caneta,
                        product2: @caderno,
                        product3: @borracha)
      total_value = 3 * 10 + 2 * 20 + 1 * 5

      expect(order.total_value).to eq(total_value)
    end

    it 'and have a valid CPF' do
      valid_cpfs = [
        '987.654.321-00',
        '714.602.380-01',
        '313.030.210-72',
        '144.796.170-60'
      ].freeze

      valid_cpfs.each do |cpf|
        expect do
          Order.new(cpf: cpf.to_s,
                    product1: @caneta,
                    product2: @caderno,
                    product3: @borracha)
        end.not_to raise_error
      end
    end

    it 'and cant have an invalid CPF' do
      invalid_cpfs = [
        '111.111.111-11',
        '222.222.222-22',
        '333.333.333-33'
      ].freeze

      invalid_cpfs.each do |cpf|
        expect do
          Order.new(cpf: cpf.to_s,
                    product1: @caneta,
                    product2: @caderno,
                    product3: @borracha)
        end.to raise_error(RuntimeError)
      end
    end

    it 'and can add discounts coupons' do
      order = Order.new(cpf: '813.841.100-70',
                        product1: @caneta,
                        product2: @caderno,
                        product3: @borracha,
                        discount: 10)
      total_value = 3 * 10 + 2 * 20 + 1 * 5

      expect(order.total_value).to eq(total_value - total_value * 10 / 100)
    end
  end
end
