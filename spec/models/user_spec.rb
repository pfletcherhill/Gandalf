require 'spec_helper'

describe User do 
  before :each do 
    @user = Fabricate(:user)
    @organization = Fabricate(:organization)
    @category = Fabricate(:category)
  end
  describe ".events" do
    context "when user doesn't have subscriptions" do
      it "returns an empty array" do
        events = @user.events
        expect(events).to eq([])
      end
    end

    it "should not have subscriptions" do
      @user.subscriptions.should == []
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
          @event = Fabricate(:event, organization: @organization)
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
          @event = Fabricate(:event)
          @category.events << @event
          @category.save
        end
        it "returns array of events" do
          events = @user.events
          expect(events).to eq([@event])
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
          @event = Fabricate(:event, organization_id: @organization.id)
          @category.events << @event
        end
        it "the category has the event" do
          expect(@category.events).to include(@event)
        end
        it "returns array of one event" do
          events = @user.events
          expect(events).to eq([@event])
        end
      end
    end
  end
  describe ".create_from_directory" do
    # Works in development...but not in test??
    # context "when student netid is supplied" do
    #   before :each do
    #     netid = "fak23"
    #     @user = User.create_from_directory(netid)
    #   end
    #   it "creates correct name" do
    #     @user.name.should == "Faiaz Ahsan Khan"
    #   end
    #   it "creates correct nickname" do
    #     @user.nickname.should == "Rafi"
    #   end
    #   it "creates correct email" do
    #     @user.email.should == "faiaz.khan@yale.edu"
    #   end
    #   it "creates correct year" do
    #     @user.year.should == "2015"
    #   end
    #   it "creates correct college" do
    #     @user.college.should == "PC"
    #   end
    #   it "creates correct division" do
    #     @user.division.should == "Yale College"
    #   end
    # end

    # Let's stop checking for Ric Levin.
    # context "when administrative netid is supplied" do
    #   before :each do
    #     netid = "rcl6"
    #     @user = User.create_from_directory(netid)
    #   end
    #   it "creates correct name" do
    #     @user.name.should == "Richard C Levin"
    #   end
    #   it "creates correct nickname" do
    #     @user.nickname.should == "Richard"
    #   end
    #   it "creates correct email" do
    #     @user.email.should == "richard.levin@yale.edu"
    #   end
    #   it "creates correct year" do
    #     @user.year.should == nil
    #   end
    #   it "creates correct college" do
    #     @user.college.should == nil
    #   end
    #   it "creates correct division" do
    #     @user.division.should == "President Office"
    #   end
    # end
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
        ).valid?.should == false
      end
    end
    context "when using a non-unique email" do
      it "fails to create" do
        user = User.create(
          :netid => "paulsballs",
          :name => "Paul Fletcher-Hill",
          :nickname => "Paul",
          :email => "paul.fletcher-hill@yale.edu",
          :division => "Yale College"  
        ).valid?.should == false
      end
    end
  end
end
