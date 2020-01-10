module Spree
  module Api
    module V1
      class ReviewsController < Spree::Api::BaseController
        before_action :load_product
        rescue_from ActiveRecord::RecordNotFound, with: :render

        def create
          params[:review][:rating].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:rating].blank?
          params[:review][:specs].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:specs].blank?
          params[:review][:freshness].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:freshness].blank?
          params[:review][:delivery_on_time].sub!(/\s*[^0-9]*\z/, "") unless params[:review][:delivery_on_time].blank?

          @review = Spree::Review.new(review_params)
          @review.product = @product
          @review.product_mask = @product.product_mask
          # @review.user = spree_current_user if spree_user_signed_in?
          @review.user = Spree::User.find_by(id: params[:user_id])
          @review.ip_address = request.remote_ip
          @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

          # authorize! :create, @review
          if @review.user.present?
            if @review.save
              render status: :ok,
                     json: { "success": true, "message": [I18n.t("review.create.success")], "data": { review: @review } }
            else
              render status: :error,
                     json: { "success": false, "message": [@review.errors.full_messages.flatten.join(", ")], "data": { review: [] } }
            end
          end
        end

        private

        def load_product
          @product = Spree::Product.friendly.find_by(id: params[:product_id])
        end

        def permitted_review_attributes
          %i[rating title review name show_identifier specs freshness delivery_on_time]
        end

        def review_params
          params.require(:review).permit(permitted_review_attributes)
        end
      end
    end
  end
end
