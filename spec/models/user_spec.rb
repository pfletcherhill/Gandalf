require 'spec_helper'

describe User do 
  before :each do 
    @user = User.create(
      :netid => "prf8",
      :name => "Paul Fletcher-Hill",
      :nickname => "Paul",
      :email => "paul.fletcher-hill@yale.edu",
      :division => "Yale College"
      )
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

  describe "getting from directory" do 
    context "rafi" do
      netid = "fak23"
      it "makes right user" do
        u = User.create_from_directory netid
        u.name.should eql "Faiaz Ahsan Khan"
        u.nickname.should eql "Rafi"
        u.email.should eql "faiaz.khan@yale.edu"
        u.year.should eql "2015"
        u.college.should eql "PC"
        u.division.should eql "Yale College"
      end
    end
=begin 
This test fails because test use Paul is created, but works without validations
    context "paul" do
      netid = "prf8"
      it "makes right user" do
        u = User.create_from_directory netid
        u.name.should eql "Paul Rodgers Fletcher-Hill"
        u.nickname.should eql "Paul"
        u.email.should eql "paul.fletcher-hill@yale.edu"
        u.year.should eql "2015"
        u.college.should eql "PC"
        u.division.should eql "Yale College"
      end
    end
=end
    context "pres levin" do
      netid = "rcl6"
      it "makes right user" do
        u = User.create_from_directory netid
        u.name.should eql "Richard C Levin"
        u.nickname.should eql "Richard"
        u.email.should eql "richard.levin@yale.edu"
        u.year.should eql nil
        u.college.should eql nil
        u.division.should eql "President Office"
      end

    end
  end

  context "uniqueness validation" do
    context "netid" do
      it "fails on same netid" do
        u = User.create(
          :netid => "prf8",
          :name => "Paul Fletcher-Hill",
          :nickname => "Paul",
          :email => "paul.hill@yale.edu",
          :division => "Yale College"
          ).valid?.should eql false
      end
    end
    context "email" do
      it "fails on same email" do
        u = User.create(
          :netid => "paultheball",
          :name => "Paul Fletcher-Hill",
          :nickname => "Paul",
          :email => "paul.fletcher-hill@yale.edu",
          :division => "Yale College"
          )
        puts "\n\nTEST\n\n"
        p u
        p @user
        u.valid?.should eql false
      end
    end
  end

  context "presence validation" do
    it "fails on no netid" do
      u = User.create(
        :name => "Paul Fletcher-Hill",
        :nickname => "Paul",
        :email => "paul.hill@yale.edu",
        :division => "Yale College"
        ).valid?.should eql false
    end
    it "fails on no email" do
      u = User.create(
        :netid => "prf",
        :name => "Paul Fletcher-Hill",
        :nickname => "Paul",
        :division => "Yale College"
        ).valid?.should eql false
    end
    it "fails on no name" do
      u = User.create(
        :netid => "prf",
        :nickname => "Paul",
        :email => "paul.hill@yale.edu",
        :division => "Yale College"
        ).valid?.should eql false
    end
    it "fails on no nickname" do
      u = User.create(
        :netid => "prf",
        :name => "Paul Fletcher-Hill",
        :email => "paul.hill@yale.edu",
        :division => "Yale College"
        ).valid?.should eql false
    end
    it "fails on no division" do
      u = User.create(
        :netid => "prf",
        :name => "Paul Fletcher-Hill",
        :nickname => "Paul",
        :email => "paul.hill@yale.edu",
        ).valid?.should eql false
    end

  end
end