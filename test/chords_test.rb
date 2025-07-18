#
#
#

require "test_helper"


#
# ourchords = generate_west_chords();  
# 
# 2020 - the following testing code is commented out, as I don't know
# why it was put together in the first place.
# 
# """ if __name__ == "__main__":
#     for i in ourchords:
#         print(str(i));


class MusicSetTheory::ChordsTest < Test::Unit::TestCase

  #
  include MusicSetTheory::Temperament
  include MusicSetTheory
  extend  MusicSetTheory

  #
  def self.startup
    # generate_west_chords  # これがあると、なぜか個別にはパスする. scales, temperament はフェイル.
    #generate_west_chords()
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
class MusicSetTheory::ChordsTest

  # Like test_seq_dict, but checks dictionary in WestTemp.
  test "ChordsTest  - temperament_dict" do
    # wt = WestTemp
    wt = self.west_temp

    #
    assert_false self.majorchord.nil?

    # orig.
    assert_true wt.check_nseqby_subdict(NSEQ_CHORD)
    assert_true wt.check_nseqby_name(NSEQ_CHORD, "Major")
    assert_true wt.check_nseqby_name(NSEQ_CHORD, "Minor")
    assert_false wt.check_nseqby_name(NSEQ_CHORD, "Chord")
    assert_true wt.check_nseqby_abbrv(NSEQ_CHORD, "maj")
    assert_true wt.check_nseqby_abbrv(NSEQ_CHORD, "min")
    assert_false wt.check_nseqby_abbrv(NSEQ_SCALE, "chd")
    assert_true wt.check_nseqby_seqpos(NSEQ_CHORD, [0, 4, 7])

    # orig.
    assert_equal self.majorchord, wt.get_nseqby_name("Major", NSEQ_CHORD)
  end

  test "ChordsTest  - get_notes_for_chord" do
    assert_equal ["E\u266d"],
      self.majorchord.get_notes_for_key("Eb", 0, [0])
    assert_equal ["G"],
      self.majorchord.get_notes_for_key("Eb", 1, [0])
    assert_equal ["B\u266d"],
      self.majorchord.get_notes_for_key("Eb", 2, [0])
    assert_equal ["E\u266d"],
      self.majorchord.get_notes_for_key("Eb", 3, [0])
    assert_equal ["E\u266d", "B\u266d"],
      self.majorchord.get_notes_for_key("Eb", 0, [0, 2])
    assert_equal ["G", "E\u266d"],
      self.majorchord.get_notes_for_key("Eb", 1, [0, 2])
    assert_equal ["B\u266d", "G"],
      self.majorchord.get_notes_for_key("Eb", 2, [0, 2])
    assert_equal ["E\u266d", "B\u266d"],
      self.majorchord.get_notes_for_key("Eb", 3, [0, 2])
    assert_equal ["E\u266d", "G"],
      self.majorchord.get_notes_for_key("Eb", 0, [0, 1])
    assert_equal ["G", "B\u266d"],
      self.majorchord.get_notes_for_key("Eb", 1, [0, 1])
    assert_equal ["B\u266d", "E\u266d",],
      self.majorchord.get_notes_for_key("Eb", 2, [0, 1])
    assert_equal ["E\u266d", "G"],
      self.majorchord.get_notes_for_key("Eb", 3, [0, 1])
  end

  test "ChordsTest  - get_posn_for_chord" do
    assert_equal [0, 4, 7],
      self.majorchord.get_posn_for_offset(0, raz: false)
    assert_equal [0, 4, 7],
      self.majorchord.get_posn_for_offset(0, raz: true)
    assert_equal [0],
      self.majorchord.get_posn_for_offset(0, [0], raz: false)
    assert_equal [0],
      self.majorchord.get_posn_for_offset(0, [0], raz: true)
    assert_equal [4],
      self.majorchord.get_posn_for_offset(0, [1], raz: false)
    assert_equal [0],
      self.majorchord.get_posn_for_offset(0, [1], raz: true)
    assert_equal [7],
      self.majorchord.get_posn_for_offset(0, [2], raz: false)
    assert_equal [0],
      self.majorchord.get_posn_for_offset(0, [2], raz: true)
    assert_equal [4, 7, 0],
      self.majorchord.get_posn_for_offset(1, raz: false)
    assert_equal [0, 3, 8],
      self.majorchord.get_posn_for_offset(1, raz: true)
    assert_equal [4],
      self.majorchord.get_posn_for_offset(1, [0], raz: false)
    assert_equal [0],
      self.majorchord.get_posn_for_offset(1, [0], raz: true)
  end

end

#
#         def test_get_notes_for_chord(self):
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 0, [0]), ['E\u266d']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 1, [0]), ['G']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 2, [0]), ['B\u266d']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 3, [0]), ['E\u266d']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 0, [0, 2]), ['E\u266d', 'B\u266d']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 1, [0, 2]), ['G', 'E\u266d']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 2, [0, 2]), ['B\u266d', 'G']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 3, [0, 2]), ['E\u266d', 'B\u266d']);
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 0, [0, 1]), ['E\u266d', 'G']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 1, [0, 1]), ['G', 'B\u266d']);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 2, [0, 1]), ['B\u266d', 'E\u266d',]);            
#             self.assertEqual(self.majorchord.get_notes_for_key("Eb", 
#                 3, [0, 1]), ['E\u266d', 'G']);                
# 
# 
#         def test_get_posn_for_chord(self):
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, 
#                 raz=False), [0, 4, 7]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, 
#                 raz=True), [0, 4, 7]);            
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, [0], 
#                 raz=False), [0]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, [0], 
#                 raz=True), [0]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, [1], 
#                 raz=False), [4]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, [1], 
#                 raz=True), [0]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, [2], 
#                 raz=False), [7]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(0, [2], 
#                 raz=True), [0]);                
#             self.assertEqual(self.majorchord.get_posn_for_offset(1, 
#                 raz=False), [4, 7, 0]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(1, 
#                 raz=True), [0, 3, 8]);            
#             self.assertEqual(self.majorchord.get_posn_for_offset(1, [0], 
#                 raz=False), [4]);
#             self.assertEqual(self.majorchord.get_posn_for_offset(1, [0], 
#                 raz=True), [0]);


#### endof filename: test/chords_test.rb
