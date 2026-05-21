# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    prepend_before_action(only: :destroy) { request.env["devise.skip_flash"] = true }

    private

    def respond_with(resource, _opts = {})
      render json: { message: "Login realizado.", user: resource }, status: :ok
    end

    def respond_to_on_destroy(_resource = nil)
      render json: { message: "Logout realizado." }, status: :ok
    end
  end
end
