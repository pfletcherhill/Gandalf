# User model spec

require 'spec_helper'

describe Gandalf::Utilities do
  context "make slug" do
    it "covers every corner case imaginable" do
      test = "som eb!-name7 !@#$%^*()}{\\|.,+_"
      expect(make_slug(test)).to eq("som-eb-name7-_")
    end
  end
end
