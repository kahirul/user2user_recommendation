require './user_similarity_weight'

class UserRecommendation
  attr_accessor :user_id, :product_id, :num_product, :num_people

  def initialize(user_id, product_id, num_product = 10, num_people = 10)
    @user_id = user_id
    @product_id = product_id
    @num_product = num_product
    @num_people = num_people
  end

  def products
    raw_products = Hash.new
    temp_products = Hash.new
    final_products = Hash.new
    users = UserSimilarityWeight.all(conditions: { user_id1: @user_id },limit: @num_people, sort: [[ :weight, :desc ]])
    users.each do |u|
      u_products = ProductView.all.where(user_id: u.user_id2).only(:product_id, :view_count).desc(:view_count).limit(@num_product).to_a
      u_products.each { |p| raw_products[p] = p.view_count }
    end

    # Remove sorted desc duplicate product
    raw_products.sort_by { |k, v| v}.each do |k, v|
      temp_products[k.product_id] = k
    end

    # Get top N viewed products
    temp_products.each do |k, v|
      final_products[v] = v.view_count
    end
    final_products.sort_by{|k, v| -v}[0...@num_product].map { |k, v| k.product_id }
  end
end
