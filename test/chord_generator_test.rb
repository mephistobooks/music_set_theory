#
# filename: test/chord_generator_test.rb
#

require "test_helper"


#
#
#
class MusicSetTheory::ChordGeneratorTest < Test::Unit::TestCase

  #
  include MusicSetTheory::Temperament
  include MusicSetTheory
  extend  MusicSetTheory

  #
  def self.startup
    @west_temp_orig = WestTemp.deep_dup
  end
  def self.shutdown
    Object.send(:remove_const, :WestTemp) if Object.const_defined?(:WestTemp)
    Object.const_set(:WestTemp, self.west_temp_orig)
  end
  def self.west_temp_orig; @west_temp_orig; end
  def west_temp_orig; self.class.send(__method__); end

  #
  attr_accessor :majorchord
  attr_accessor :west_temp
  def setup
    # self.west_temp = self.west_temp_orig.deep_dup
    self.west_temp = MusicSetTheory::Temperament.WestTempNew()

    #@west_temp_orig = WestTemp.deep_dup
    generate_west_chords(self.west_temp)  # ok.

    #self.majorchord = WestTemp.get_nseqby_name("Major", NSEQ_CHORD)
    #ng.self.majorchord = WestTempNew().get_nseqby_name("Major", NSEQ_CHORD)
    # self.majorchord = WestTemp.get_nseqby_name("Major", NSEQ_CHORD)
    #self.majorchord = MusicSetTheory::Temperament.WestTempNew().
    #  get_nseqby_name("Major", NSEQ_CHORD)  #ng.

    # self.majorchord = WestTemp.get_nseqby_name("Major", NSEQ_CHORD)
    self.majorchord = self.west_temp.get_nseqby_name("Major", NSEQ_CHORD)
    assert_false self.majorchord.nil?
  end

  def teardown
    Object.send(:remove_const, :WestTemp) if Object.const_defined?(:WestTemp)
    Object.const_set(:WestTemp, self.class.west_temp_orig)
  end

end


#
#
#
class MusicSetTheory::ChordGeneratorTest

  #
  test "int_to_roman (normal)" do
    ret = int_to_roman(1)
    exp = "I"
    assert_equal exp, ret

    ret = int_to_roman(4)
    exp = "IV"
    assert_equal exp, ret

    ret = int_to_roman(10)
    exp = "X"
    assert_equal exp, ret

    ret = int_to_roman(14)
    exp = "XIV"
    assert_equal exp, ret

    ret = int_to_roman(2000)
    exp = "MM"
    assert_equal exp, ret

    ret = int_to_roman(1999)
    exp = "MCMXCIX"
    assert_equal exp, ret

  end

  test "int_to_roman (abnormal)" do
    tmp = assert_raise{ int_to_roman(0) }
    ret = tmp.class
    exp = ArgumentError
    assert_equal exp, ret

    tmp = assert_raise{ int_to_roman(-1) }
    ret = tmp.class
    exp = ArgumentError
    assert_equal exp, ret

    tmp = assert_raise{ int_to_roman(1.5) }
    ret = tmp.class
    exp = TypeError
    assert_equal exp, ret

  end

  test "make_roman_numeral_list" do
    ret = make_roman_numeral_list(2)
    exp = %w[I II]
    assert_equal exp, ret

    ret = make_roman_numeral_list(10)
    exp = %w[I II III IV V VI VII VIII IX X]
    assert_equal exp, ret

  end

  #
  test "makebaserep" do

    ret = makebaserep("C#", 0)
    exp = "0" + M_SHARP
    assert_equal exp, ret

    ret = makebaserep("C#", 1)
    exp = "1" + M_SHARP
    assert_equal exp, ret

    ret = makebaserep("Cbb", 1)
    exp = "1" + M_FLAT*2
    assert_equal exp, ret

  end

end


#
#
#
class MusicSetTheory::ChordGeneratorTest

  #
  test "populate_scale_chords (1)" do
    tmp = populate_scale_chords("Dorian", "C", ["Seventh"] )

    ret = tmp.class
    exp = MusicSetTheory::ScaleChords
    assert_equal exp, ret

    ret = tmp.to_a.size
    # exp = 8
    exp = 2
    assert_equal exp, ret

    ret = tmp.to_a[0].size
    exp = 4
    assert_equal exp, ret

    ret = tmp.to_a[0]
    exp = [
      "Dorian", "C",
      ["0", "1", "2♭", "3", "4", "5", "6♭"],
      ["I", "II", "III", "IV", "V", "VI", "VII"],
    ]
    assert_equal exp, ret

    ret = tmp.to_a
    exp = [
      ["Dorian", "C",
       ["0", "1", "2♭", "3", "4", "5", "6♭"],
       ["I", "II", "III", "IV", "V", "VI", "VII"], ],
      [
        [ "Seventh", "", "", ["0", "2♭", "4", "6♭"], ],
        [ "Seventh", "", "", ["1", "3", "5", "0"],   ],
        [ "Seventh", "", "", ["2♭", "4", "6♭", "1"], ],
        [ "Seventh", "", "", ["3",  "5", "0", "2♭"], ],
        [ "Seventh", "", "", ["4",  "6♭", "1", "3"], ],
        [ "Seventh", "", "", ["5",  "0", "2♭", "4"], ],
        [ "Seventh", "", "", ["6♭", "1", "3", "5"],  ],
      ]
    ]
    assert_equal exp, ret

  end

  #
  test "populate_scale_chords (2)" do
    tmp = populate_scale_chords("Ionian", "C", ["Major", "Seventh"] )

    ret = tmp.to_a
    exp = [
      ["Ionian",
        "C",
        ["0", "1", "2", "3", "4", "5", "6"],
        ["I", "II", "III", "IV", "V", "VI", "VII"]],
      [["Major", "", "", ["0", "1", "2", "3", "4", "5", "6"]],
       ["Major", "", "", ["1", "2", "3", "4", "5", "6", "0"]],
       ["Major", "", "", ["2", "3", "4", "5", "6", "0", "1"]],
       ["Major", "", "", ["3", "4", "5", "6", "0", "1", "2"]],
       ["Major", "", "", ["4", "5", "6", "0", "1", "2", "3"]],
       ["Major", "", "", ["5", "6", "0", "1", "2", "3", "4"]],
       ["Major", "", "", ["6", "0", "1", "2", "3", "4", "5"]],
      ],
      [["Seventh", "", "", ["0", "2", "4", "6"]],
       ["Seventh", "", "", ["1", "3", "5", "0"]],
       ["Seventh", "", "", ["2", "4", "6", "1"]],
       ["Seventh", "", "", ["3", "5", "0", "2"]],
       ["Seventh", "", "", ["4", "6", "1", "3"]],
       ["Seventh", "", "", ["5", "0", "2", "4"]],
       ["Seventh", "", "", ["6", "1", "3", "5"]],
      ],
    ]
    assert_equal exp, ret

  end

end


#### endof filename: test/chord_generator_test.rb
