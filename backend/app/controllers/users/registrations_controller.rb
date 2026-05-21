# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: { message: "Conta criada.", user: resource }, status: :created
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_content
      end
    end
  end
end
