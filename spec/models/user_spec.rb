# User model spec

require 'spec_helper'

describe User do
  describe "associations" do
    # TO TEST:
    # subscribed_teams
    # team_events
    # subscribed_categories
    # category_events
    # access level to groups
    # add as member to organization team
    # follow organization
    # follow category
    # 
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
          expect { Fabricate(:user, netid: @user.netid )}.to raise_error
        end
      end
      
      context "when using a non-unique email" do
        it "fails to create" do
          expect { Fabricate(:user, email: @user.email )}.to raise_error
        end
      end
    end
    
    describe ".subscribe_to" do
      context "valid group" do
        before :each do
          @user = Fabricate(:user)
          @group = make_group(@group_name)
        end
        
        it "creates subscription" do
          expect(@user.subscriptions.count).to eq 0
          member_stub = stub_request(:post, API_MEMBER_REGEX(:create, @group.apps_id)).to_return({
            status: 200,
            headers: {'Content-Type' => 'application/json'},
            body: {
              kind: 'admin#directory#member',
              id: make_random_hash,
              email: @user.email,
              role: 'MEMBER',
              type: 'MEMBER'
            }.to_json
          })
          @user.subscribe_to(@group.id)
          assert_requested member_stub
          expect(@user.subscriptions.count).to eq 1
        end
      end
      context "bogus group" do
        it "throws error" do
          expect { @user.subscribe_to(-1) }.to raise_error
        end
      end
    end   
  end
end
