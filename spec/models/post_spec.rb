require 'rails_helper'

describe Post, type: :model do

  it 'is not valid with a name of less than three characters' do
    post = Post.new(name: "kf")
    expect(post).to have(1).error_on(:name)
    expect(post).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    first = FactoryGirl.create(:post)
    second = FactoryGirl.build(:post)
    expect(second).to have(1).error_on(:name)
  end

end