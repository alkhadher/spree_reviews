# frozen_string_literal: true

# Add access to reviews/ratings to the product model

module Spree
  module ProductMaskDecorator
    def self.prepended(base)
      base.has_many :reviews
    end

    def recalculate_rating
      self[:reviews_count] = reviews.reload.default_approval_filter.count
      quality_rating = []
      specs_rating = []
      freshness_rating = []
      delivery_on_time_rating = []
      reviews.default_approval_filter.each do |review|
        quality_rating << review.rating.to_f
        specs_rating << review.specs.to_f
        freshness_rating << review.freshness.to_f
        delivery_on_time_rating << review.delivery_on_time.to_f
      end
      self.avg_quality_rating = reviews_count.positive? ? quality_rating.sum / reviews_count : 0
      self.avg_specs_rating = reviews_count.positive? ? specs_rating.sum / reviews_count : 0
      self.avg_freshness_rating = reviews_count.positive? ? freshness_rating.sum / reviews_count : 0
      self.avg_delivery_on_time_rating = reviews_count.positive? ? delivery_on_time_rating.sum / reviews_count : 0
      self[:avg_rating] = reviews_count.positive? ? (avg_quality_rating + avg_specs_rating + avg_freshness_rating + avg_delivery_on_time_rating) / 4.0 : 0
      save
      products.each(&:touch)
    end

    def stars
      avg_rating.try(:round) || 0
    end

  end
end
::Spree::ProductMask.prepend Spree::ProductMaskDecorator
