# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do
  
	before(:each) do
	  @attr = { name: "Foo Bar", 
	  	        email: "user@example.com",
	  	        password: "foobar",
	  	        password_confirmation: "foobar" }
	end

  it "should crete a new instance give a valid attribute" do
  	User.create!(@attr)
  end

  it "should require a name" do
  	no_name_user = User.new(@attr.merge(name: ""))
  	no_name_user.should_not be_valid
  end

  it "should require an email address" do
  	no_email_user = User.new(@attr.merge(email: ""))
  	no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
  	long_name = "a" * 51
  	long_name_user = User.new(@attr.merge(name: long_name))
  	long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
  	addresses = %w[user@example.com THE_USER@foo.bar.org first.last@foo.jp]
  	addresses.each do |address|
  		valid_email_user = User.new(@attr.merge(email: address))
  		valid_email_user.should be_valid
  	end
  end

  it "should reject invalid email addresses" do
  	addresses = %w[user@example,com THE_USER_at_foo.bar.org first.last@foo.]
  	addresses.each do |address|
  		invalid_email_user = User.new(@attr.merge(email: address))
  		invalid_email_user.should_not be_valid
  	end
  end

  it "should reject duplilcate email addresses" do
  	User.create!(@attr)
  	user_with_dup_email = User.new(@attr)
  	user_with_dup_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
  	User.create!(@attr.merge(email: @attr[:email].upcase))
  	user_with_dup_email = User.new(@attr)
  	user_with_dup_email.should_not be_valid
  end

  describe "passwords" do
    
  	before(:each) do
  	  @user = User.new(@attr) #params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    it "should have a passworld attribute" do
    	@user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
    	@user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do
    
    it "should require a password" do
    	User.new(@attr.merge(password: "", password_confirmation: "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
    	User.new(@attr.merge(password_confirmation: "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
    	short = "a" * 5
    	hash = @attr.merge(password: short, password_confirmation: short)

    	User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
    	long = "a" * 41
    	hash = @attr.merge(password: long, password_confirmation: long)

    	User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    
  	before(:each) do
  	  @user = User.create!(@attr)
  	end

    it "should have an encrypted password attribute" do
    	@user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
    	@user.encrypted_password.should_not be_blank
    end

    it "should have a salt" do
    	@user.should respond_to(:salt)
    end

	  describe "has_password? method" do
	    
	    it "should exist" do
	    	@user.should respond_to(:has_password?)
	    end

	    it "should return true if the passwords match" do
	    	@user.has_password?(@attr[:password]).should be_true
	    end

	    it "should return false if the passwords don't match" do
	    	@user.has_password?("invalid").should be_false
	    end
	  end
  end

  describe "authenticate method" do
    
    before(:each) do
  	  @user = User.create!(@attr)
  	end

    it "should exist" do
    	User.should respond_to(:authenticate)
    end

    it "should return nil on email/password mismatch" do
    	User.authenticate(@attr[:email], "wrong_password").should be_nil
    end

    it "should return nil for an email address with no user" do
    	User.authenticate("bar@foo.com", @attr[:password]).should be_nil
    end

    it "should return the user on email/password match" do
    	User.authenticate(@attr[:email], @attr[:password]).should == @user
    end
  end
end