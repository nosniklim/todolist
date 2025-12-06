require 'rails_helper'

RSpec.describe 'Lists', type: :request do
  let(:user) { create(:user) }
  let!(:list) { create(:list, user: user) }

  before { sign_in user } # Devise のヘルパーでログイン

  describe 'GET /list/new' do
    it '200 OK を返す' do
      get new_list_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /list' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { list: { title: 'New List' } } }

      it 'リストを作成し、ルートにリダイレクトする' do
        expect do
          post list_index_path, params: valid_params
        end.to change(List, :count).by(1)
        expect(response).to redirect_to(root_path)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { list: { title: '' } } }

      it 'リストを作成せず、新規作成画面を再表示する' do
        expect do
          post list_index_path, params: invalid_params
        end.not_to change(List, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /list/:id/edit' do
    it '200 OK を返す' do
      get edit_list_path(list)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /list/:id' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { list: { title: 'Updated Title' } } }

      it 'リストを更新し、ルートにリダイレクトする' do
        patch list_path(list), params: valid_params
        expect(list.reload.title).to eq('Updated Title')
        expect(response).to redirect_to(root_path)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { list: { title: '' } } }

      it 'リストを更新せず、編集画面を再表示する' do
        patch list_path(list), params: invalid_params
        expect(list.reload.title).not_to eq('')
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /list/:id' do
    it 'リストを削除し、ルートにリダイレクトする' do
      expect do
        delete list_path(list)
      end.to change(List, :count).by(-1)
      expect(response).to redirect_to(root_path)
    end
  end
end
