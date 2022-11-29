require 'spec_helper'
require_relative '../main'
require 'rack/test'
require 'faraday'

RSpec.describe 'Sales App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'Não deve fazer um pedido com cpf inválido' do
    input = {
      cpf: '987.654.321-01'
    }

    conn =  Faraday.new(
      url: 'http://127.0.0.1:4567',
      headers: { 'Content-Type' => 'application/json' } 
    )
    response = conn.post('/checkout', input.to_json)
    expect(response.status).to eq(422)
    expect(response.body).to eq('Invalid CPF')
  end

  it 'Deve fazer um pedido com 3 produtos' do
    input = {
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

    conn =  Faraday.new(
      url: 'http://127.0.0.1:4567',
      headers: { 'Content-Type' => 'application/json' } 
    )
    response = conn.post('/checkout', input.to_json)
    expect(response.status).to eq(201)
    expect(response.body).to eq('65')
  end
end
