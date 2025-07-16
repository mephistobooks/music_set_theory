# frozen_string_literal: true
#
# filename: test/musutility_test.rb
#

require "test_helper"


#
#
#
class MusicTheory::MusUtilityTest < Test::Unit::TestCase
  attr_accessor :eseq
  attr_accessor :one_elem_seq, :one_elem_seq_one
  attr_accessor :two_elem_seq, :two_elem_seq_rot
  attr_accessor :three_elem_seq, :three_elem_seq_left, :three_elem_seq_right
  attr_accessor :all_test_seq
  def self.startup;   end
  def self.shutdown;  end

  #
  def setup
    self.eseq = []

    self.one_elem_seq     = ["0"]
    self.one_elem_seq_one = ["1"]

    self.two_elem_seq     = ["0", "1"]
    self.two_elem_seq_rot = ["1", "0"]

    self.three_elem_seq = ["0", "1", "2", "3"];
    self.three_elem_seq_left = ["1", "2", "3", "0"];
    self.three_elem_seq_right = ["3", "0", "1", "2"]; 
    self.all_test_seq = [
      [], ["0"], ["0", "1"], ["1", "0"],
      ["0", "1", "2", "3"], ["1", "2", "3", "0"], 
      ["3", "0", "1", "2"]
    ];
  end

  def teardown
  end

  #
  include MusicTheory
end


#
#
#
class MusicTheory::MusUtilityTest

  test "rotate" do

    #
    assert_equal self.eseq, rotate(self.eseq, 0)
    assert_equal self.eseq, rotate(self.eseq, 1)
    assert_equal self.eseq, rotate(self.eseq, -1)

    #
    assert_equal self.one_elem_seq, rotate(self.one_elem_seq, 0)
    assert_equal self.one_elem_seq, rotate(self.one_elem_seq, 1)
    assert_equal self.one_elem_seq, rotate(self.one_elem_seq, -1)

    #
    assert_equal self.two_elem_seq, rotate(self.two_elem_seq, 0)
    assert_equal self.two_elem_seq_rot, rotate(self.two_elem_seq, 1)
    assert_equal self.two_elem_seq_rot, rotate(self.two_elem_seq, -1)

    #
    assert_equal self.three_elem_seq, rotate(self.three_elem_seq, 0)
    assert_equal self.three_elem_seq_left, rotate(self.three_elem_seq, 1)
    assert_equal self.three_elem_seq_right, rotate(self.three_elem_seq, -1)

  end

  test "scalar_addition" do

    # Tests on small sequences.
    #
    assert_equal [],    scalar_addition([], 0, 0)
    assert_equal [],    scalar_addition([], 0, 5)
    assert_equal [],    scalar_addition([], 5, 0)
    assert_equal [],    scalar_addition([], 5, 5)

    #
    assert_equal [1],   scalar_addition([1], 0, 0)
    assert_equal [1],   scalar_addition([1], 0, 5)
    assert_equal [6],   scalar_addition([1], 5, 0)
    assert_equal [1],   scalar_addition([1], 5, 5)

    #
    assert_equal [-1],  scalar_addition([-1], 0, 0)
    assert_equal [4],   scalar_addition([-1], 0, 5)
    assert_equal [4],   scalar_addition([-1], 5, 0)
    assert_equal [4],   scalar_addition([-1], 5, 5)

    # Tests on sequences used in the representation of the major chord.
    #
    assert_equal [0, 3, 8],  scalar_addition([4, 7, 0], -4, 12)
    assert_equal [0, 5, 9],  scalar_addition([3, 8, 0], -3, 12)
    assert_equal [0, 4, 7],  scalar_addition([5, 9, 0], -5, 12)
    assert_equal [0, 2, 5],  scalar_addition([2, 4, 0], -2,  7)
    assert_equal [0, 3, 5],  scalar_addition([2, 5, 0], -2,  7)
    assert_equal [0, 2, 4],  scalar_addition([3, 5, 0], -3,  7)

  end

  test "rotate_and_zero" do
    # Tests on small sequences.
    #
    assert_equal [], rotate_and_zero([], 0, 0)
    assert_equal [], rotate_and_zero([], 0, 5)
    assert_equal [], rotate_and_zero([], 5, 0)
    assert_equal [], rotate_and_zero([], 5, 5)

    #
    assert_equal [0], rotate_and_zero([1], 0, 0)
    assert_equal [0], rotate_and_zero([1], 0, 5)
    assert_equal [0], rotate_and_zero([1], 5, 0)
    assert_equal [0], rotate_and_zero([1], 5, 5)

    #
    assert_equal [0], rotate_and_zero([-1], 0, 0)
    assert_equal [0], rotate_and_zero([-1], 0, 5)
    assert_equal [0], rotate_and_zero([-1], 5, 0)
    assert_equal [0], rotate_and_zero([-1], 5, 5)

    # Tests on sequences used in the representation of the major chord.
    #
    assert_equal [0, 3, 8], rotate_and_zero([0, 4, 7], 1, 12)
    assert_equal [0, 5, 9], rotate_and_zero([0, 3, 8], 1, 12)
    assert_equal [0, 4, 7], rotate_and_zero([0, 5, 9], 1, 12)
    assert_equal [0, 2, 5], rotate_and_zero([0, 2, 4], 1,  7)
    assert_equal [0, 3, 5], rotate_and_zero([0, 2, 5], 1,  7)
    assert_equal [0, 2, 4], rotate_and_zero([0, 3, 5], 1,  7)

    # And one for the diminished chord.
    #
    assert_equal [0, 3, 6, 9], rotate_and_zero([0, 3, 6, 9], 1, 12)

  end


  test "multislice" do
    zero_slice = [0]
    one_slice  = [1]
    zero_and_one_slice = zero_slice + one_slice

    # For all sequences, the empty slice ([]) acting on it returns [],
    # irrespective of the modulo and the offset.
    #
    for i in 0...8
      for j in 0...4
        for k in self.all_test_seq

          # assert_equal self.eseq, multislice(k, self.eseq, i, j)
          assert_equal self.eseq, multislice(k, self.eseq, mod: i, offset: j)

        end
      end
    end

    # For all sequences of one element, the zero slice ([0]) returns the same 
    # sequence, irrespective of the modulo and the offset.
    #
    for i in 0...4
      for j in 0...4

        assert_equal self.one_elem_seq,
          # multislice(self.one_elem_seq, zero_slice, i, j)
          multislice(self.one_elem_seq, zero_slice, mod: i, offset: j)

      end
    end

    # Now we try slices on two elements.
    #
    for j in 0...4
      for i in [0, 2, 4, 6]

        assert_equal self.one_elem_seq,
          # multislice(self.two_elem_seq, zero_slice, j, i)
          multislice(self.two_elem_seq, zero_slice, mod: j, offset: i)
        assert_equal self.one_elem_seq_one,
          # multislice(self.two_elem_seq_rot, zero_slice, j, i)
          multislice(self.two_elem_seq_rot, zero_slice, mod: j, offset: i)

      end

      #
      for i in [1, 3, 5, 7]

        assert_equal self.one_elem_seq_one,
          # multislice(self.two_elem_seq, zero_slice, j, i)
          multislice(self.two_elem_seq, zero_slice, mod: j, offset: i)
        assert_equal self.one_elem_seq,
          # multislice(self.two_elem_seq_rot, zero_slice, j, i)
          multislice(self.two_elem_seq_rot, zero_slice, mod: j, offset: i)

      end
    end

  end

  test "repseq" do
    doubler = lambda{|x| x * 2 }

    assert_equal "",      repseq(self.eseq)
    assert_equal "",      repseq(self.eseq, doubler)
    assert_equal "1",     repseq([1])
    assert_equal "2",     repseq([1], doubler)
    assert_equal "1, 2",  repseq([1, 2])
    assert_equal "2, 4",  repseq([1, 2], doubler)
  end

  test "enl_seq" do
    assert_equal self.eseq, enl_seq(self.eseq, self.eseq)
    assert_equal self.eseq, enl_seq(self.eseq, self.one_elem_seq)
    assert_equal self.eseq, enl_seq(self.one_elem_seq, self.eseq)
    assert_equal [["0", "1"]], enl_seq([["0"]], self.one_elem_seq_one)
  end

  test "norm_seq" do
    assert_equal [0, 5, 6], norm_seq([7, 6, 5],  7)
    assert_equal [0, 5, 6], norm_seq([5, 6, 7],  7)
    assert_equal [5, 6, 7], norm_seq([7, 6, 5], 12)
    assert_equal [5, 6, 7], norm_seq([5, 6, 7], 12)
  end

end


#### endof filename: test/musutility_test.rb
