require 'spec_helper'

describe Group do
  before :each do
    @name = "Test name"
    @group = make_group(@name)
  end

  context ".create" do
    it "makes google api objects" do
      # This is really a test for make_group.
      expect(@group.name).to eq @name
    end

    it "rejects duplicate slugs" do
      @sName = "tEst-name! "
      expect { make_group(@sName) }.to raise_error
    end
  end

  context ".read" do
    it "reads google api objects" do
      pending "necessary?"
    end

    it "synchronizes with Gandalf database in background" do
      pending "v3?"
    end
  end

  context ".update" do
    it "updates google api objects" do
      pending "laziness"
    end
  end

  context ".destroy" do
    it "deletes google api objects" do
      group_stub = stub_request(:delete, API_GROUP_REGEX(:destroy, @group.apps_id))

      cal_stub = stub_request(:delete, API_CAL_REGEX(:destroy, @group.apps_cal_id))
      # acl_stub = stub_request(:delete, API_ACL_REGEX(:destroy, @group.apps_cal_id,
      #   @group.apps_cal_id))
      @group.destroy
      assert_requested group_stub
      assert_requested cal_stub
      # assert_requested acl_stub
    end
  end
end
