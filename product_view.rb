require 'rubygems'
require 'mongoid'

class ProductView
  include Mongoid::Document
  field :user_id, type: Integer
  field :product_id, type: Integer
  field :view_count, type: Integer

  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("demo")
  end

  def to_s
    "#{user_id} - #{product_id} - #{view_count}"
  end
end


