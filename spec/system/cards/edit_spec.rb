# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards: Edit', type: :system do
  let(:password)  { 'password' }
  let!(:user)     { create(:user, password: password, password_confirmation: password) }
  let(:card_form) { CardFormPage.new }
  let(:top_page) { TopPage.new }

  # Lists
  let!(:list_a) { create(:list, user: user, title: 'A', position: 1) }
  let!(:list_b) { create(:list, user: user, title: 'B', position: 2) }

  # Cards
  let!(:card_a1) { create(:card, list: list_a, title: 'Task A1', memo: 'Memo A1', position: 1) }
  let!(:card_a2) { create(:card, list: list_a, title: 'Task A2', memo: 'Memo A2', position: 2) }
  let!(:card_b1) { create(:card, list: list_b, title: 'Task B1', memo: 'Memo B1', position: 1) }

  before { sign_in_as(user) }

  describe '画面表示' do
    it '表示内容が正しいこと' do
      visit edit_list_card_path(list_a, card_a1)

      expect(page).to have_selector('label', text: 'Title')
      expect(page).to have_selector('label', text: 'Memo')
      expect(page).to have_selector('label', text: 'List')
      expect(page).to have_selector('label', text: 'Position')

      # TODO: [data-testid="input-card-title"]
      expect(page).to have_selector('.cardeditForm_title',  wait: 1)
      # TODO: [data-testid="input-card-memo"]
      expect(page).to have_selector('.cardeditForm_memo',   wait: 1)
      # TODO: [data-testid="select-card-list"]
      expect(page).to have_selector('.cardeditForm_list', wait: 1)
      # TODO: [data-testid="select-card-position"]
      expect(page).to have_selector('.cardeditForm_position', wait: 1)

      # List
      # TODO: [data-testid="select-card-list"]
      options = all('.cardeditForm_list select option').map(&:text)
      expect(options).to include('A', 'B')

      # Position
      # TODO: [data-testid="select-card-position"]
      options = all('.cardeditForm_position select option').map(&:text)
      expect(options).to include('1', '2')
    end
  end

  describe '更新成功' do
    it 'タイトル・メモを変更して保存するとトップページに遷移すること' do
      visit edit_list_card_path(list_a, card_a1)

      card_form.fill_title('Task A1 (updated)')
      card_form.fill_memo('Memo A1 (updated)')
      click_button 'Save'

      expect(page).to have_current_path(root_path)
      top_page.within_list('A') do
        # TODO: [data-testid="card-title"]
        expect(all('.card_title').map(&:text)).to eq ['Task A1 (updated)', 'Task A2']
      end
    end

    it 'positionを変更するとリスト内のカードの表示順が並べ替えられること' do
      visit edit_list_card_path(list_a, card_a1)
      card_form.select_position(2)
      click_button 'Save'

      expect(page).to have_current_path(root_path)
      top_page.within_list('A') do
        # TODO: [data-testid="card-title"]
        expect(all('.card_title').map(&:text)).to eq ['Task A2', 'Task A1']
      end
    end

    it 'リストBに移動して、Bの末尾に配置されること' do
      visit edit_list_card_path(list_a, card_a2)
      card_form.select_list('B')
      # card_form.select_position(2) # positionは変更しない
      click_button 'Save'

      expect(page).to have_current_path(root_path)
      top_page.within_list('A') do
        # TODO: [data-testid="card-title"]
        expect(all('.card_title').map(&:text)).to eq ['Task A1']
      end
      top_page.within_list('B') do
        # TODO: [data-testid="card-title"]
        expect(all('.card_title').map(&:text)).to eq ['Task B1', 'Task A2']
      end
    end

    it 'リストBに移動して、Bの先頭に配置されること' do
      visit edit_list_card_path(list_a, card_a2)
      card_form.select_list('B')
      card_form.select_position(1) # B1のカードの位置を選択
      click_button 'Save'

      expect(page).to have_current_path(root_path)
      top_page.within_list('A') do
        # TODO: [data-testid="card-title"]
        expect(all('.card_title').map(&:text)).to eq ['Task A1']
      end
      top_page.within_list('B') do
        # TODO: [data-testid="card-title"]
        expect(all('.card_title').map(&:text)).to eq ['Task A2', 'Task B1']
      end
    end
  end

  describe '更新失敗' do
    it 'タイトル未入力で保存すると、入力値を保持して同画面を再表示' do
      visit edit_list_card_path(list_a, card_a1)
      card_form.fill_title('')
      card_form.fill_memo('keep me')
      click_button 'Save'

      # 失敗（編集画面に留まる）
      expect(page).to have_current_path(list_card_path(list_a, card_a1)) # PATCH path

      # エラーメッセージ
      # TODO: [data-testid="form-error"], [data-testid="flash"]
      expect(page).to have_selector('.text-danger')

      # 入力保持の確認
      expect(page).to have_field('Title', with: '')
      expect(page).to have_field('Memo', with: 'keep me')
    end
  end
end
