# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lists: Edit', type: :system do
  let(:password) { 'password' }
  let!(:user)    { create(:user, password: password, password_confirmation: password) }
  let(:list_form) { ListFormPage.new }

  let!(:list1) { create(:list, user: user, title: 'Todo',  position: 1) }
  let!(:list2) { create(:list, user: user, title: 'Doing', position: 2) }
  let!(:list3) { create(:list, user: user, title: 'Done',  position: 3) }

  before do
    sign_in_as(user)
  end

  describe '画面表示' do
    it '表示内容が正しいこと' do
      visit edit_list_path(list1)

      # ラベル確認
      expect(page).to have_selector('.listeditForm_title label', text: 'Title')
      expect(page).to have_selector('.listeditForm_position label', text: 'Position')

      # フィールドの存在確認
      # TODO: [data-testid="input-list-title"]
      expect(page).to have_selector('.listeditForm_title input')
      # TODO: [data-testid="select-list-position"]
      expect(page).to have_selector('.listeditForm_position select')

      # position
      # TODO: [data-testid="select-list-position"]
      options = all('.listeditForm_position select option').map(&:text)
      expect(options).to include('1', '2', '3')
    end
  end

  describe '更新成功' do
    it 'タイトルを変更して保存するとトップページに遷移すること' do
      visit edit_list_path(list1)
      list_form.fill_title('Todo (updated)')
      click_button 'Save'
      expect(page).to have_current_path(root_path)

      # 更新されたタイトルが表示されていることを確認
      # TODO: [data-testid="board"]
      within('.listWrapper') do
        # TODO: [data-testid="list-title"]
        expect(page).to have_selector('.list_header_title', text: 'Todo (updated)')
      end
    end

    it 'positionを変更するとリストの表示順が並べ替えられること' do
      visit edit_list_path(list2)
      list_form.select_position(1)
      click_button 'Save'
      expect(page).to have_current_path(root_path)

      # リストの表示順が変更されていることを確認
      # TODO: [data-testid="list-title"]
      titles = all('.list_header_title').map(&:text)
      expect(titles).to eq %w[Doing Todo Done]

      # positionが更新されていることを確認
      expect(List.where(user: user).order(:position).pluck(:title)).to eq %w[Doing Todo Done]
      expect(List.where(user: user).order(:position).pluck(:position)).to eq [1, 2, 3]
    end
  end

  describe '更新失敗' do
    it 'タイトル未入力で保存すると、入力値を保持して同画面を再表示' do
      visit edit_list_path(list3)
      # positionを1に変更（失敗時に入力値が保持されることを確認）
      list_form.fill_title('')
      list_form.select_position(1)
      click_button 'Save'

      # 失敗（編集画面に留まる）
      expect(page).to have_current_path(list_path(list3)) # PATCH path (not /edit)

      # エラーメッセージ
      # TODO: [data-testid="form-error"], [data-testid="flash"]
      expect(page).to have_selector('.text-danger')

      # 入力保持の確認
      expect(page).to have_field('Title', with: '')
      expect(page).to have_field('Position', with: 1)
    end
  end
end
