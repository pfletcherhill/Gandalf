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
      @user.subscriptions.should == []
    end
  end
  context "with subscriptions" do
  end

  describe "getting from directory" do 
    context "rafi" do
      netid = "fak23"
      it "makes right user" do
        u = User.create_user_from_directory netid
        u.name.should eql "Faiaz Ahsan Khan"
        u.nickname.should eql "Rafi"
        u.email.should eql "faiaz.khan@yale.edu"
        u.year.should eql "2015"
        u.college.should eql "PC"
        u.division.should eql "Yale College"
      end
    end
    context "paul" do
      netid = "prf8"
      it "makes right user" do
        u = User.create_user_from_directory netid
        u.name.should eql "Paul Rodgers Fletcher-Hill"
        u.nickname.should eql "Paul"
        u.email.should eql "paul.fletcher-hill@yale.edu"
        u.year.should eql "2015"
        u.college.should eql "PC"
        u.division.should eql "Yale College"
      end
    end
    context "pres levin" do
      netid = "rcl6"
      it "makes right user" do
        u = User.create_user_from_directory netid
        u.name.should eql "Richard C Levin"
        u.nickname.should eql "Richard"
        u.email.should eql "richard.levin@yale.edu"
        u.year.should eql nil
        u.college.should eql nil
        u.division.should eql "President Office"
      end

    end
  end
end