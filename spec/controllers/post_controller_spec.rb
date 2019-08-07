# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe '#index' do
    it 'dost not responds successfully' do
      get :index
      expect(response).to_not be_successful
    end
  end
end
