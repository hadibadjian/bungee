require 'spec_helper'

describe UsersController do
	render_views

  describe "Get 'show'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    	get 'show', id: @user.id
    end

    it "should be successful" do
    	response.should be_success
    end

    it "should find the right user" do
    	assigns(:user).should == @user
    end

    it "should have the right title" do
    	response.should have_selector("title", content: @user.name)
    end

    it "should have the user's name" do
    	response.should have_selector("h1", content: @user.name)
    end

    it "should have the right URL" do
    	response.should have_selector('div>a', content: user_path(@user), 
    		                                        href: user_path(@user))
    end
  end

  describe "GET 'new'" do

    before(:each) do
      get 'new'
    end

    it "returns http success" do
      response.should be_success
    end

    it "should have the right title" do
    	response.should have_selector("title", content: "Sign up")
    end
  end

end
