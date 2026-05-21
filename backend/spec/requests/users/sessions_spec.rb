# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Sessions", type: :request do
  describe "DELETE /users/sign_out" do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }

    it "revokes the session and returns success" do
      delete "/users/sign_out", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq("message" => "Logout realizado.")
    end
  end
end
