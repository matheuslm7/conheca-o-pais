# frozen_string_literal: true

if Rails.env.test?
  FactoryBot.definition_file_paths = [Rails.root.join("spec/factories")]
end
