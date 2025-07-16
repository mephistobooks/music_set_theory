# frozen_string_literal: true
#
# filename: test/music_theoty_test.rb
#

require "test_helper"


#
#
#
class MusicTheoryTest < Test::Unit::TestCase
  def self.startup;   end
  def self.shutdown;  end

  def setup;    end
  def teardown; end
end


#
#
#
class MusicTheoryTest

  test "VERSION" do
    assert do
      ::MusicTheory.const_defined?(:VERSION)
    end
  end

  test "something useful" do

    ret = 1
    exp = 1
    assert_equal exp, ret

  end

end


#### endof filename: test/music_theoty_test.rb
