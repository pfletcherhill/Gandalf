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
        before :each do
          @subscription = Fabricate(:subscription, user_id: @user.id)
        end
        
        it "should have one subscription" do
          @user.subscriptions.count.should == 1
          @user.subscriptions.first.should == @subscription
        end
      end
      
      context "when the user has many subscriptions" do
        before :each do
          Fabricate(:subscription, user_id: @user.id)
          Fabricate(:subscription, user_id: @user.id)
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
        before :each do
          @group = Fabricate(:group)
          @user.add_group(@group.id)
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
        before :each do
          @user.add_group(Fabricate(:group).id)
          @user.add_group(Fabricate(:group).id)
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
        before :each do
          @organization = Fabricate(:organization)
          @subscription = Fabricate(:subscription, user_id: @user.id, subscribeable_id: @organization.id, subscribeable_type: "Organization", group_id: @organization.followers_group.id)
        end
        
        context "when the organization has no events" do
          it "should be empty" do
            @user.events.should be_empty
          end
        end
        
        context "when the organization has events" do
          before :each do
            @event = Fabricate(:event, organization_id: @organization.id)
            @event.groups << @organization.followers_group
          end
          
          it "should have events" do
            @user.events.count.should == 1
            @user.events.first.should == @event
          end
        end
      end
    end
  end
  
  context "methods" do
    
    before :each do
      @user = Fabricate(:user)
    end
    
    describe ".create" do
      context "when using a non-unique netid" do
        it "fails to create" do
          user = User.create(
            :netid => @user.netid,
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
            :email => @user.email,
            :division => "Yale College"
          )
          user.valid?.should be_false
        end
      end
    end
    
    describe ".add_group" do
      context "when adding a valid group" do
        before :each do
          @user = Fabricate(:user)
          @group = Fabricate(:group)
        end
        
        it "creates a subscription" do
          @user.subscriptions.count.should == 0
          @user.add_group(@group.id)
          @user.subscriptions.count.should == 1
        end
      end
    end   
  end
end
