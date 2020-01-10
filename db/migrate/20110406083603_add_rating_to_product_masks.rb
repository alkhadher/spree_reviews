class AddRatingToProductMasks < SpreeExtension::Migration[4.2]
  def self.up
    if table_exists?('product_masks')
      add_column :product_masks, :avg_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :product_masks, :reviews_count, :integer, default: 0, null: false
      add_column :product_masks, :avg_quality_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :product_masks, :avg_specs_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :product_masks, :avg_freshness_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :product_masks, :avg_delivery_on_time_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5

    elsif table_exists?('spree_product_masks')
      add_column :spree_product_masks, :avg_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :spree_product_masks, :reviews_count, :integer, default: 0, null: false
      add_column :spree_product_masks, :avg_quality_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :spree_product_masks, :avg_specs_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :spree_product_masks, :avg_freshness_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
      add_column :spree_product_masks, :avg_delivery_on_time_rating, :decimal, default: 0.0, null: false, precision: 7, scale: 5
    end
  end

  def self.down
    if table_exists?('product_masks')
      remove_column :product_masks, :reviews_count
      remove_column :product_masks, :avg_rating
      remove_column :product_masks, :avg_quality_rating
      remove_column :product_masks, :avg_specs_rating
      remove_column :product_masks, :avg_freshness_rating
      remove_column :product_masks, :avg_delivery_on_time_rating

    elsif table_exists?('spree_product_masks')
      remove_column :spree_product_masks, :reviews_count
      remove_column :spree_product_masks, :avg_rating
      remove_column :spree_product_masks, :avg_quality_rating
      remove_column :spree_product_masks, :avg_specs_rating
      remove_column :spree_product_masks, :avg_freshness_rating
      remove_column :spree_product_masks, :avg_delivery_on_time_rating
    end
  end
end
