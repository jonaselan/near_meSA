require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  let(:valid_attributes) { attributes_for(:user) }

  let(:invalid_attributes) { attributes_for(:invalid_user) }

  describe 'GET #index' do
    it 'returns a success response' do
      user = User.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    before :each do
      @user = create(:user)
    end
    it 'returns a success response' do
      get :show, params: { id: @user.to_param }

      expect(response).to be_successful
    end

    it 'returns a body without password' do
      get :show, params: { id: @user.to_param }
      expect(response.body.include? 'password').to be_falsey
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post :create, params: { user: valid_attributes }

        user = User.last
        expect(user).to_not be_nil
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new user' do
        post :create, params: { user: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @user = create(:user, email: 'email@email.com')
    end

    context 'with valid params' do
      let(:new_attributes) {
        attributes_for(:user, email: 'change@email.com')
      }

      it 'updates the requested user' do
        put :update, params: {
          id: @user.to_param, user: new_attributes
        }

        @user.reload
        expect(@user.email).to eq('change@email.com')
      end

      it 'renders a JSON response with the user' do
        put :update, params: {
          id: @user.to_param, user: valid_attributes
        }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'does not change user\'s attributes' do
        put :update, params: {
          id: @user,
          user: invalid_attributes
        }

        @user.reload
        expect(@user.email).to eq('email@email.com')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = create :user
      expect {
        delete :destroy, params: {
          id: user.to_param
        }
      }.to change(User, :count).by(-1)
    end
  end
end
