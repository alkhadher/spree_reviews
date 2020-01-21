class Spree::Review < ActiveRecord::Base
  belongs_to :product_mask, touch: true
  belongs_to :product
  belongs_to :user, class_name: Spree.user_class.to_s
  has_many   :feedback_reviews

  after_save :recalculate_product_rating, if: :recalculate_rating?
  after_destroy :recalculate_product_rating

  validates :name, :review, presence: true
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    message: Spree.t(:you_must_enter_value_for_rating)
  }
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    message: Spree.t(:you_must_enter_value_for_rating)
  }
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    message: Spree.t(:you_must_enter_value_for_rating)
  }
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    message: Spree.t(:you_must_enter_value_for_rating)
  }
  default_scope { order("spree_reviews.created_at DESC") }

  scope :localized, ->(lc) { where("spree_reviews.locale = ?", lc) }
  scope :most_recent_first, -> { order("spree_reviews.created_at DESC") }
  scope :oldest_first, -> { reorder("spree_reviews.created_at ASC") }
  scope :preview, -> { limit(Spree::Reviews::Config[:preview_size]).oldest_first }
  scope :approved, -> { where(approved: true) }
  scope :not_approved, -> { where(approved: false) }
  scope :default_approval_filter, -> { Spree::Reviews::Config[:include_unapproved_reviews] ? all : approved }

  def recalculate_rating?
    self.approved? || Spree::Reviews::Config[:include_unapproved_reviews]
  end
  def feedback_stars
    return 0 if feedback_reviews.size <= 0

    ((feedback_reviews.sum(:rating) / feedback_reviews.size) + 0.5).floor
  end

  def recalculate_product_rating
    product_mask.recalculate_rating if product_mask.present?
  end
end
