# frozen_string_literal: true

# Add access to reviews/ratings to the product model

module Spree
  module ProductDecorator
    def self.prepended(base)
      base.has_many :reviews
    end

  end
end
::Spree::Product.prepend Spree::ProductDecorator
