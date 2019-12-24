class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_not_found

  private

  def render_404_not_found
    head :not_found
  end
end
