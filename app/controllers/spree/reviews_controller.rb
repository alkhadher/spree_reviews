class Spree::ReviewsController < Spree::StoreController
  helper Spree::BaseHelper
  before_action :load_product, only: [:index, :new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @approved_reviews = Spree::Review.approved.where(product_mask: @product_mask)
  end

  def new
    @review = Spree::Review.new(product_mask: @product_mask)
    authorize! :create, @review
  end

  # save if all ok
  def create
    params[:review][:rating].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:rating].blank?
    params[:review][:specs].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:specs].blank?
    params[:review][:freshness].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:freshness].blank?
    params[:review][:delivery_on_time].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:delivery_on_time].blank?
    @review = Spree::Review.new(review_params)
    @review.product = @product
    @review.product_mask = @product.product_mask
    @review.user = spree_current_user if spree_user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

    authorize! :create, @review
    if @review.save
      flash[:notice] = Spree.t(:review_successfully_submitted)
      redirect_to spree.product_path(@product)
    else
      render :new
    end
  end

  private

  def load_product
    @product = Spree::Product.friendly.find(params[:product_id])
    @product_mask = @product.product_mask
  end

  def permitted_review_attributes
    %i[rating title review name show_identifier specs freshness delivery_on_time]
  end

  def review_params
    params.require(:review).permit(permitted_review_attributes)
  end
end
