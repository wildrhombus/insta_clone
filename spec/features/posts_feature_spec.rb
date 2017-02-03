require 'rails_helper'

feature 'posts' do
  context 'not logged in' do
    scenario 'should not display a prompt to add a post' do
      visit '/posts'
      expect(page).not_to have_link 'Add a post'
    end
  end

  context 'logged in, no posts have been added' do
    before do
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
    end

    scenario 'should display a prompt to add a post' do
      visit '/posts'
      expect(page).to have_content 'No posts yet'
      expect(page).to have_link 'Add a post'
    end
  end

  context 'posts have been added' do
    before do
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
      FactoryGirl.create(:post)
    end

    scenario 'display posts' do
      visit '/posts'
      expect(page).to have_content('Selfie')
      expect(page).not_to have_content('No posts yet')
    end
  end

  context 'creating posts' do
    before do
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
    end

    scenario 'prompts user to fill out a form, then displays the new post' do
      visit '/posts'
      click_link 'Add a post'
      fill_in 'Name', with: 'Selfie'
      click_button 'Create Post'
      expect(page).to have_content 'Selfie'
      expect(current_path).to eq '/posts'
    end

    context 'an invalid post' do
      scenario 'does not let you submit a name that is too short' do
        visit '/posts'
        click_link 'Add a post'
        fill_in 'Name', with: 'kf'
        click_button 'Create Post'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'editing posts' do

    before do
      FactoryGirl.create(:post, name: 'McDonalds', description: 'Flat burgers')
    end

    scenario 'not logged in, unable to edit post' do
      visit '/posts'
      expect(page).not_to have_link 'Edit McDonalds'
    end

    context 'logged in' do
      before do
        user = FactoryGirl.create(:user)
        login_as(user, :scope => :user)

        visit '/posts'
        click_link 'Add a post'
        fill_in 'Name', with: 'Selfie'
        click_button 'Create Post'
      end

      scenario 'let a user edit a post' do
        visit '/posts'
        click_link 'Edit Selfie'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        fill_in 'Description', with: 'Deep fried goodness'
        click_button 'Update Post'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(page).to have_content 'Deep fried goodness'
        expect(current_path).to eq '/posts'
      end
    end

    context 'different user' do
      before do
        user2 = FactoryGirl.create(:user, email: 'differentuser@test.com', password: 'fdsfds')
        login_as(user2, :scope => :user)
      end
      scenario 'user unable edit a post' do
        visit '/posts'
        expect(page).to have_link 'Add a post'
        expect(page).not_to have_content 'Edit Selfie'
      end
    end

  end

  context 'deleting posts' do
    before do
      FactoryGirl.create(:post, name: 'McDonalds', description: 'Flat burgers')
    end

    scenario 'not logged in, unable to delete post' do
      visit '/posts'
      expect(page).not_to have_link 'Delete McDonalds'
    end

    context 'logged in' do
      before do
        user = FactoryGirl.create(:user)
        login_as(user, :scope => :user)

        visit '/posts'
        click_link 'Add a post'
        fill_in 'Name', with: 'Selfie'
        click_button 'Create Post'
      end

      scenario 'removes a post when a user clicks a delete link' do
        visit '/posts'
        click_link 'Delete Selfie'
        expect(page).not_to have_content 'Selfie'
        expect(page).to have_content 'Post deleted successfully'
      end
    end

    context 'different user' do
      before do
        user = FactoryGirl.create(:user)
        login_as(user, :scope => :user)

        visit '/posts'
        click_link 'Add a post'
        fill_in 'Name', with: 'Selfie'
        click_button 'Create Post'

        logout
        user2 = FactoryGirl.create(:user, email: 'differentuser@test.com', password: 'fdsfds')
        login_as(user2, :scope => :user)
      end
      scenario 'user unable delete a post' do
        visit '/posts'
        expect(page).to have_link 'Add a post'
        expect(page).not_to have_content 'Delete Selfie'
      end
    end
  end
end