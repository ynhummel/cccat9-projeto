# order_spec.rb
require 'order'

describe Order do
  context 'Must create an Order' do
    before(:each) do
      @caneta = Product.new(description: 'Caneta',price: 10,quantity: 3)
      @caderno = Product.new(description: 'Caderno',price: 20,quantity: 2)
      @borracha = Product.new(description: 'Borracha',price: 5,quantity: 1)
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
      expect do
        Order.new(cpf: '111.111.111-11',
                  product1: @caneta,
                  product2: @caderno,
                  product3: @borracha)
        end.to raise_error(StandardError)

      expect do
        Order.new(cpf: '12.123.134-21',
                  product1: @caneta,
                  product2: @caderno,
                  product3: @borracha)
        end.to raise_error(StandardError)
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
