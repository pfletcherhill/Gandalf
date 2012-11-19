require 'spec_helper'

describe User do 
  before :each do 
    @user = User.create(:name => "Paul", :email => "paul@yale.edu")
    @organization = Organization.create(:name => "TEDxYale")
    @category = Category.create(:name => "TED Talks")
  end
  describe ".events" do
    context "when user doesn't have subscriptions" do
      it "returns an empty array" do
        events = @user.events
        events.should == []
      end
    end
    context "when user is subscribed to an organization" do
      before :each do
        @user.subscribed_organizations << @organization
      end
      context "and organization has no events" do
        it "returns an empty array" do
          events = @user.events
          events.should == []
        end
      end
      context "and organization has events" do
        before :each do
          @event = Event.create(:name => "TEDxYale City 2.0", :organization_id => @organization.id)
        end
        it "returns array of events" do
         events = @user.events
         events.should == [@event]
        end
      end
    end
    context "when user is subscribed to a category" do
      before :each do
        @user.subscribed_categories << @category
      end
      context "and category has no events" do
        it "returns an empty array" do
          events = @user.events
          events.should == []
        end
      end
      context "and category has events" do
        before :each do
          @event = Event.create(:name => "TEDxYale City 2.0", :organization_id => @organization.id)
          @category.events << @event
        end
        it "returns array of events" do
          events = @user.events
          events.should == [@event]
        end
      end
    end
    context "when user is subscribed to category and organization" do
      before :each do 
        @user.subscribed_categories << @category
        @user.subscribed_organizations << @organization
      end
      context "and both have the same event" do
        before :each do
          @event = Event.create(:name => "TEDxYale City 2.0", :organization_id => @organization.id)
          @category.events << @event
        end
        it "returns array of one event" do
          events = @user.events
          events.should == [@event]
        end
      end
    end
  end
end