require 'rails_helper'

feature 'posts' do
  context 'no posts have been added' do
    scenario 'should display a prompt to add a post' do
      visit '/posts'
      expect(page).to have_content 'No posts yet'
      expect(page).to have_link 'Add a post'
    end
  end

  context 'posts have been added' do
    before do
      Post.create(name: 'selfie')
    end

    scenario 'display posts' do
      visit '/posts'
      expect(page).to have_content('selfie')
      expect(page).not_to have_content('No posts yet')
    end
  end

  context 'creating posts' do
    scenario 'prompts user to fill out a form, then displays the new post' do
      visit '/posts'
      click_link 'Add a post'
      fill_in 'Name', with: 'selfie'
      click_button 'Create Post'
      expect(page).to have_content 'selfie'
      expect(current_path).to eq '/posts'
    end
  end

  context 'viewing posts' do

    let!(:selfie){ Post.create(name:'selfie') }

    scenario 'lets a user view a post' do
      visit '/posts'
      click_link 'selfie'
      expect(page).to have_content 'selfie'
      expect(current_path).to eq "/posts/#{selfie.id}"
    end

  end

  context 'editing posts' do

    before { Post.create name: 'Selfie', description: 'Selfie' }

    scenario 'let a user edit a post' do
      visit '/posts'
      click_link 'Edit Selfie'
      fill_in 'Name', with: 'First Selfie'
      fill_in 'Description', with: 'In the park'
      click_button 'Update Post'
      expect(page).to have_content 'First Selfie'
      expect(page).to have_content 'In the park'
      expect(current_path).to eq '/posts'
    end

  end

  context 'deleting posts' do

    before { Post.create name: 'Selfie', description: 'Party' }

    scenario 'removes a post when a user clicks a delete link' do
      visit '/posts'
      click_link 'Delete Selfie'
      expect(page).not_to have_content 'Selfie'
      expect(page).to have_content 'Post deleted successfully'
    end

  end
end