require 'sinatra'
require 'json'
require_relative 'lib/order'

post '/checkout' do
  request.body.rewind
  data = request.body.read
  parsed_data = JSON.parse(data)

  product1 = Product.new(description: parsed_data['products'][0]['description'],
                         price: parsed_data['products'][0]['price'],
                         quantity: parsed_data['products'][0]['quantity'])

  product2 = Product.new(description: parsed_data['products'][1]['description'],
                         price: parsed_data['products'][1]['price'],
                         quantity: parsed_data['products'][1]['quantity'])

  product3 = Product.new(description: parsed_data['products'][2]['description'],
                         price: parsed_data['products'][2]['price'],
                         quantity: parsed_data['products'][2]['quantity'])
  order = Order.new(cpf: parsed_data['cpf'],
                    product1: product1,
                    product2: product2,
                    product3: product3)
  status 201
  headers 'Content-Type' => 'application/json'
  body order.total_value.to_s
  rescue => e
    halt 422, { 'Content-Type' => 'application/json' }, 'Invalid CPF'
end
