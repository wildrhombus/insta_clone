FactoryGirl.define do
  factory :user do
    sequence (:email) do |n|
      "person#{n}@example.com"
    end
    password 'f4k3p455w0rd'
  end
end