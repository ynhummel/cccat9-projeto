require_relative '../main'
require 'rack/test'

RSpec.describe 'Sales App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:each) do
    $memory = []
  end

  it 'GET orders' do
    @caneta = Product.new(description: 'Caneta', price: 10, quantity: 3)
    @caderno = Product.new(description: 'Caderno', price: 20, quantity: 2)
    @borracha = Product.new(description: 'Borracha', price: 5, quantity: 1)

    order = Order.new(cpf: '813.841.100-70',
                      product1: @caneta,
                      product2: @caderno,
                      product3: @borracha)
    $memory << order
    get '/orders'
    expect(last_response.body).to eq($memory.to_s)
  end

  it 'POST order' do
    order = {
      cpf: '813.841.100-70',
      products: [
        {
          description: 'Caneta',
          price: 10,
          quantity: 2
        },
        {
          description: 'Caderno',
          price: 20,
          quantity: 2
        },
        {
          description: 'Borracha',
          price: 5,
          quantity: 1
        }
      ]
    }

    post '/order', order.to_json, "CONTENT_TYPE" => "application/json"

    expect($memory.length).to eq(1)
  end
end
