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

  describe "POST 'create'" do
    
    describe "failure" do
    	
    	before(:each) do
    	  @attr = { name: "", email: "", password: "", password_confirmation: "" }
    	end

    	it "should have the right title" do
    		post 'create', user: @attr
    		response.should have_selector("title", content: "Sign up")
    	end
    	
    	it "should render the 'new' page" do
    		post 'create', user: @attr
    		response.should render_template('new')
    	end

    	it "should not create the user" do
    		lambda do
    			post 'create', user: @attr
    		end.should_not change(User, :count)
    	end
    end

    describe "success" do
      
      before(:each) do
        @attr = { name: "New User", email: "user@example.org",
                  password: "foobar", password_confirmation: "foobar"}
      end

      it "should create a user" do
      	lambda do
    			post 'create', user: @attr
    		end.should change(User, :count).by(1)
      end

      it "should redirect to the user 'show' page" do
      	post 'create', user: @attr
      	response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
      	post 'create', user: @attr
      	flash[:success].should =~ /Welcome #{assigns(:user).name}/i
      end
    end

  end
end
