require 'spec_helper'

describe User do 
  before :each do 
    @user = User.new(:name => "Paul", :email => "paul@yale.edu")
  end
  context "without subscriptions" do
    it "user should be user" do
      @user.should == @user
    end
    it "should not have subscriptions" do
      p @user.subscriptions
      #@user.subscriptions.should == []
    end
  end
  context "with subscriptions" do
  end
end