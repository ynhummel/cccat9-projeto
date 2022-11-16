class Product
  attr_reader :description, :price, :quantity

  def initialize(description:, price:, quantity:)
    @description = description
    @price = price
    @quantity = quantity
  end
end
