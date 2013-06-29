# User model spec

require 'spec_helper'
include Gandalf::Utilities

describe User do
  context "associations" do
    
    before :each do
      @user = Fabricate(:user)
    end
    
    describe "subscriptions" do
      
      context "when the user is created" do
        it "should be empty" do
          @user.subscriptions.should be_empty
        end
      end
      
      context "when the user has one subscription" do
        before do
          @subscription = Fabricate(:subscription)
          @user.subscriptions << @subscription
        end
        
        it "should have one subscription" do
          @user.subscriptions.count.should == 1
          @user.subscriptions.first.should == @subscription
        end
      end
      
      context "when the user has many subscriptions" do
        before do
          @user.subscriptions << Fabricate(:subscription)
          @user.subscriptions << Fabricate(:subscription)
        end
        
        it "should have many subscriptions" do
          @user.subscriptions.count.should == 2
        end
      end
    end
    
    describe "groups" do
      
      context "when the user is created" do
        it "should be empty" do
          @user.groups.should be_empty
        end
      end
      
      context "when the user has one group" do
        before do
          @group = Fabricate(:group)
          @user.groups << @group
        end
        
        it "should have one group" do
          @user.groups.count.should == 1
          @user.groups.first.should == @group
        end
        
        it "should have one subscription" do
          @user.subscriptions.count.should == 1
        end
      end
      
      context "when the user has many groups" do
        before do
          @user.groups << Fabricate(:group)
          @user.groups << Fabricate(:group)
        end
        
        it "should have many groups" do
          @user.groups.count.should == 2
        end
        
        it "should have many subscriptions" do
          @user.subscriptions.count.should == 2
        end
      end
    end
    
    describe "events" do
      
      context "when the user is created" do
        it "should be empty" do
          @user.events.should be_empty
        end
      end
      
      context "when the user follows one organization" do
        before do
          @organization = Fabricate(:organization)
          @user.subscribed_organizations << @organization
        end
        
        context "when the organization has no events"
          it "should be empty" do
            @user.events.should be_empty
          end
        end
        
        context "when the organization has events" do
          before do
            @event = Fabricate(:event)
            @organization.events << @event
          end
          
          it "should have events" do
            @user.events.should.not be_empty
            @user.events.first.should == @event
          end
        end
        
      end
    end
  end
  
  context "methods" do
    
    before :each do
      Fabricate(:user)
    end
    
    describe ".create" do
      context "when using a non-unique netid" do
        it "fails to create" do
          user = User.create(
            :netid => "prf8",
            :name => "Paul Fletcher-Hill",
            :nickname => "Paul",
            :email => "paul.hill@yale.edu",
            :division => "Yale College"
          )
          user.valid?.should be_false
        end
      end
      
      context "when using a non-unique email" do
        it "fails to create" do
          user = User.create(
            :netid => "pfh",
            :name => "Paul Fletcher-Hill",
            :nickname => "Paul",
            :email => "paul.fletcher-hill@yale.edu",
            :division => "Yale College"
          )
          user.valid?.should be_false
        end
      end
    end
    
  end
end