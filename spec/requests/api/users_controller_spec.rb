# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UsersController do
  describe 'POST /api/users' do
    subject { post '/api/users', params: params }

    let(:params) { { user: { username: username, avatar: avatar } } }
    let(:username) { 'Test User' }
    let(:avatar) { fixture_file_upload('avatar.png') }

    context 'valid request' do
      it 'returns status created' do
        subject
        expect(response).to have_http_status :created
      end

      it 'returns a JSON response' do
        subject
        expect(JSON.parse(response.body)).to eql(
          'user' => {
            'id' => User.last.id,
            'username' => 'Test User'
          }
        )
      end
      it 'creates a user' do
        expect { subject }.to change { User.count }.from(0).to(1)
      end

      it 'creates a blob ' do
        expect { subject }.to change { ActiveStorage::Blob.count }.from(0).to(1)
      end
    end

    context 'missing username' do
      let(:username) { nil }

      it 'returns status unprocessable entity' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns a JSON response' do
        subject
        expect(JSON.parse(response.body)).to eql(
                                                 'errors' => ['Username can\'t be blank']
                                             )
      end

      it 'does not create a user' do
        expect { subject }.not_to change { User.count }.from(0)
      end

      it 'does not create a blob' do
        expect { subject }.not_to change { ActiveStorage::Blob.count }.from(0)
      end
    end

    context 'missing avatar' do
      let(:avatar) { nil }

      it 'returns status unprocessable entity' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns a JSON response' do
        subject
        expect(JSON.parse(response.body)).to eql(
                                                 'errors' => ['Avatar can\'t be blank']
                                             )
      end

      it 'does not create a user' do
        expect { subject }.not_to change { User.count }.from(0)
      end

      it 'does not create a blob' do
        expect { subject }.not_to change { ActiveStorage::Blob.count }.from(0)
      end
    end
  end
end
