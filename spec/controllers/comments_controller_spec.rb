# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:comment_params) { FactoryBot.attributes_for(:comment) }
  describe '#create' do
    context 'as an authenticated user' do
      it 'comment on a post' do
        expect do
          comment :create, params: { comment: comment_params}
        end.to change(user.comments, :count).by(1)
      end
    end
  end

  describe '#destroy' do

  end
end
