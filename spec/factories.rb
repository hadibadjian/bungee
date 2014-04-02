FactoryGirl.define do
	factory :user do
		name                  "Hadi Badjian"
		email                 "me@example.com"
		password              "some_password"
		password_confirmation "some_password"
	end
end