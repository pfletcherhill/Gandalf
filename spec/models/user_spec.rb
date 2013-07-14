# User model spec

require 'spec_helper'

describe User do
  describe "associations" do
    context "when a user has subscriptions" do
      pending "should have subscriptions" do
      end
      
      context "and a user has groups" do

        pending "should have groups through subscriptions" do
        end
        
        context "and at least one is a team" do
          pending "should have subscribed_teams through subscriptions" do
          end
          
          pending "should have subscribed_organizations through subscribed_teams" do
          end
          
          context "and that team has events" do
            pending "should have team_events through subscribed_teams" do
            end
          end
        end
        
        context "and at least one is a category" do
          pending "should have subscribed_categories through subscriptions" do
          end
          
          context "and that category has events" do
            pending "should have category_events through subscribed_categories" do
            end
          end
        end
        
        context "and a user has events" do
          pending "should have events through groups and subscriptions" do
          end
        end
      end
      
      context "with admin access_type" do
        pending "should have admin_organizations through subscriptions" do
        end
      end
      
      context "with member access_type" do
        pending "should have member_organizations through subscriptions" do
        end
      end
      
      context "with follower access_type" do
        pending "should have follower_organizations through subscriptions" do
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
          user = User.new(
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
          user = User.new(
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
    
    describe ".subscribe_to" do
      context "when adding a valid group" do
        before :each do
          @user = Fabricate(:user)
        end
        
        it "creates a subscription" do
          expect(@user.subscriptions.count).to eq 0
          stub_request(:any, /www.googleapis.com/).to_return({
            data: {
              id: 'hi'
            }
          })
          @user.subscribe_to(Fabricate(:group).id)
          @user.subscriptions.count.should == 1
        end
      end
    end   
  end
end
