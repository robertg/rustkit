require 'minitest/autorun'
require_relative '../test_helper'
require_relative '../../models/user'

describe Library do
  before do
    @user = Library.new
  end

  describe "saying hi" do
    it "respond with hi" do
      assert_equal "hi", @user.say_hi
    end
  end
end

