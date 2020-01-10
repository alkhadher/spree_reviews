class RecalculateRatings < SpreeExtension::Migration[4.2]
  def up
    Spree::ProductMask.reset_column_information
    Spree::ProductMask.update_all reviews_count: 0
    Spree::ProductMask.joins(:reviews).where('spree_reviews.id IS NOT NULL').find_each do |p|
      Spree::ProductMask.update_counters p.id, reviews_count: p.reviews.approved.length
      # recalculate_product_rating exists on the review, not the product
      if p.reviews.approved.count > 0
        p.reviews.approved.first.recalculate_product_rating
      end
    end
  end

  def down
  end
end
