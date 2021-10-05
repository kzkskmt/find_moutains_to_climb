require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe '新規登録' do
    before { visit new_user_path }

    describe 'ユーザー情報の作成' do
      context '新規登録する' do
        it '「ユーザー登録が完了しました」とフラッシュメッセージを表示' do
          fill_in 'user[name]', with: 'sample_user'
          fill_in 'user[email]', with: 'sample@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '新規登録'
          expect(page).to have_content 'ユーザー登録が完了しました'
          expect(page).to have_current_path root_path, ignore_query: true
        end
      end

      context 'ニックネームを空欄に設定して登録' do
        it '「ニックネームを入力してください」とエラーメッセージを表示、「ユーザー登録に失敗しました」とフラッシュメッセージを表示' do
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: 'sample@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '新規登録'
          expect(page).to have_content 'ニックネームを入力してください'
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'メールアドレスを「sample」に設定して登録' do
        it '「メールアドレスは有効な値ではありません」とエラーメッセージを表示、「ユーザー登録に失敗しました」とフラッシュメッセージを表示' do
          fill_in 'user[name]', with: 'sample_user'
          fill_in 'user[email]', with: 'sample'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '新規登録'
          expect(page).to have_content 'メールアドレスは有効な値ではありません'
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'パスワードとパスワード確認用を空欄に設定して登録' do
        it '「パスワードを入力してください」「パスワード(確認用)を入力してください」「パスワードは4文字以上で入力してください」とエラーメッセージを表示、「ユーザー登録に失敗しました」とフラッシュメッセージを表示' do
          fill_in 'user[name]', with: 'sample_user'
          fill_in 'user[email]', with: 'sample@example.com'
          fill_in 'user[password]', with: ''
          fill_in 'user[password_confirmation]', with: ''
          click_button '新規登録'
          expect(page).to have_content 'パスワードを入力してください'
          expect(page).to have_content 'パスワード(確認用)を入力してください'
          expect(page).to have_content 'パスワードは4文字以上で入力してください'
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'パスワードを「password」、パスワード(確認用)を「password_1」に設定して登録' do
        it '「パスワード(確認用)とパスワードの入力が一致しません」とエラーメッセージを表示、「ユーザー登録に失敗しました」とフラッシュメッセージを表示' do
          fill_in 'user[name]', with: 'sample_user'
          fill_in 'user[email]', with: 'sample@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password_1'
          click_button '新規登録'
          expect(page).to have_content 'パスワード(確認用)とパスワードの入力が一致しません'
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'パスワード、パスワード(確認用)を「abc」に設定して登録' do
        it '「パスワードは4文字以上で入力してください」とエラーメッセージを表示、「ユーザー登録に失敗しました」とフラッシュメッセージを表示' do
          fill_in 'user[name]', with: 'sample_user'
          fill_in 'user[email]', with: 'sample@example.com'
          fill_in 'user[password]', with: 'abc'
          fill_in 'user[password_confirmation]', with: 'abc'
          click_button '新規登録'
          expect(page).to have_content 'パスワードは4文字以上で入力してください'
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー情報の編集' do
      let!(:user) { create(:user) }

      before do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'password'
        click_button 'ログイン'
        visit edit_user_path(user.id)
      end

      context 'ニックネームを「sample」、メールアドレスを「sample@example.com」に設定して編集' do
        it 'ユーザー詳細ページへ遷移、「ユーザー情報を編集しました」とフラッシュメッセージを表示、「sample」「sample@example.com」を表示' do
          fill_in 'user[name]', with: 'sample'
          fill_in 'user[email]', with: 'sample@example.com'
          click_button '編集する'
          expect(page).to have_content 'ユーザー情報を編集しました'
          within('.user') do
            expect(page).to have_content 'sample'
            expect(page).to have_content 'sample@example.com'
          end
          expect(page).to have_current_path user_path(user.id), ignore_query: true
        end
      end

      context 'ニックネームを空欄に設定して更新' do
        it '「ニックネームを入力してください」とエラーメッセージを表示、「ユーザー情報を編集できませんでした」とフラッシュメッセージを表示' do
          fill_in 'user[name]', with: ''
          click_button '編集する'
          expect(page).to have_content 'ニックネームを入力してください'
          expect(page).to have_content 'ユーザー情報を編集できませんでした'
        end
      end

      context 'メールアドレスを空欄に設定して更新' do
        it '「メールアドレスを入力してください」とエラーメッセージを表示、「ユーザー情報を編集できませんでした」とフラッシュメッセージを表示' do
          fill_in 'user[email]', with: ''
          click_button '編集する'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'ユーザー情報を編集できませんでした'
        end
      end

      context 'メールアドレスを「sample」に設定して編集' do
        it '「メールアドレスは有効な値ではありません」とエラーメッセージを表示、「ユーザー情報を編集できませんでした」とフラッシュメッセージを表示' do
          fill_in 'user[email]', with: 'sample'
          click_button '編集する'
          expect(page).to have_content 'メールアドレスは有効な値ではありません'
          expect(page).to have_content 'ユーザー情報を編集できませんでした'
        end
      end

      context 'サムネイルを設定して編集' do
        it '「ユーザー情報を編集しました」とフラッシュメッセージを表示、ユーザー詳細ページにて設定したサムネイルを表示' do
          attach_file('user[avatar]', 'spec/fixtures/avatar.jpg')
          click_button '編集する'
          expect(page).to have_content 'ユーザー情報を編集しました'
          within('.user') do
            expect(page).to have_selector("img[src$='avatar.jpg']")
          end
          expect(page).to have_current_path user_path(user.id), ignore_query: true
        end
      end

      context '年齢を「20」と性別を「男性」と設定して編集' do
        it '「ユーザー情報を編集しました」とフラッシュメッセージを表示、ユーザー詳細ページにて年齢と性別を表示' do
          fill_in 'user[age]', with: '20'
          select '男性', from: '性別'
          click_button '編集する'
          expect(page).to have_content 'ユーザー情報を編集しました'
          within('.user') do
            expect(page).to have_content '20'
            expect(page).to have_content '男性'
          end
          expect(page).to have_current_path user_path(user.id), ignore_query: true
        end
      end

      context '年齢と空欄、性別を未回答に設定して編集' do
        it '「ユーザー情報を編集しました」とフラッシュメッセージを表示、ユーザー詳細ページにて年齢と性別が表示されない' do
          fill_in 'user[age]', with: ''
          select '未回答', from: '性別'
          click_button '編集する'
          expect(page).to have_content 'ユーザー情報を編集しました'
          within('.user') do
            expect(page).not_to have_content '20'
            expect(page).not_to have_content '男性'
          end
          expect(page).to have_current_path user_path(user.id), ignore_query: true
        end
      end
    end
  end
end
