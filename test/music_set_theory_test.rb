# frozen_string_literal: true
#
# filename: test/music_theoty_test.rb
#

require "test_helper"


#
#
#
class MusicSetTheoryTest < Test::Unit::TestCase
  def self.startup;   end
  def self.shutdown;  end

  def setup;    end
  def teardown; end
end


#
#
#
class MusicSetTheoryTest

  test "VERSION" do
    assert do
      ::MusicSetTheory.const_defined?(:VERSION)
    end
  end

  test "something useful" do

    ret = 1
    exp = 1
    assert_equal exp, ret

  end

end


#### endof filename: test/music_theoty_test.rb
