require 'rubygems'
require 'mongoid'
require './product_view'

class UserSimilarityWeight
  include Mongoid::Document
  field :user_id1, type: Integer
  field :user_id2, type: Integer
  field :weight, type: Integer

  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("demo")
  end

  def to_s
    "User 1: #{user_id1}\t User 2: #{user_id2}\t Bobot: #{weight}"
  end

  def self.build_similarity_weight
    ctr = 0
    users_id = ProductView.all.distinct(:user_id).to_a
    users_id.each do |user_id|
      this_user_products = ProductView.all.where(user_id: user_id).distinct(:product_id).to_a

      other_users = users_id.map { |e| e } # = ProductView.all.where(:user_id.ne => user_id).distinct(:user_id).to_a
      other_users.delete_if { |x| x == user_id }

      other_users.each do |other_uid|
        other_user_products = ProductView.all.where(user_id: other_uid).distinct(:product_id).to_a
        user_sim = (other_user_products & this_user_products).length
        usw = UserSimilarityWeight.new(user_id1: user_id, user_id2: other_uid, weight: user_sim)
        usw.save
      end
    end
  end
end

UserSimilarityWeight.build_similarity_weight
