# frozen_string_literal: true
#
# filename: test/scales_test.rb
#

require "test_helper"


# This tests the note_seq and scales class.
#
#
class MusicSetTheory::NoteSeq_ScalesTest < Test::Unit::TestCase

  #
  def self.startup;   end
  def self.shutdown;  end

  #
  include MusicSetTheory::Temperament
  include MusicSetTheory

  #
  attr_accessor :majorscale, :melminscale, :harmminscale
  attr_accessor :harmmajscale, :dorianscale
  attr_accessor :locrianscale, :superlocrianscale, :ultralocrianscale
  attr_accessor :dubflat7locrianscale
  attr_accessor :majorchord

  attr_accessor :west_temp
  def setup
    # for the dependancy of the state...
    #
    #
    # This is ng. WestTemp has already been changed.
    # @nseqtype_maps is different.
    #ng. self.west_temp = MusicSetTheory::Temperament.WestTempNew()
    #ng. assert_equal self.west_temp, WestTemp
    
    self.west_temp = WestTemp.deep_dup
    #self.west_temp = MusicSetTheory::Temperament.WestTempNew()  #ng.

    #
    #
    #
    assert_equal WestTemp.no_keys, self.west_temp.no_keys
    assert_equal WestTemp.nat_keys, self.west_temp.nat_keys
    assert_equal WestTemp.nat_key_posn, self.west_temp.nat_key_posn
    assert_equal WestTemp.no_nat_keys, self.west_temp.no_nat_keys
    assert_equal WestTemp.nat_key_pos_lookup, self.west_temp.nat_key_pos_lookup
    assert_equal WestTemp.pos_lookup_nat_key, self.west_temp.pos_lookup_nat_key
    assert_equal WestTemp.nat_key_lookup_order, self.west_temp.nat_key_lookup_order
    assert_equal WestTemp.parsenote, self.west_temp.parsenote
    assert_equal WestTemp.seq_maps, self.west_temp.seq_maps
    #ng. assert_equal WestTemp, self.west_temp

    #
    self.majorscale   = MajorScale
    self.melminscale  = MelMinorScale
    self.harmminscale = HarmMinorScale
    self.harmmajscale = HarmMajorScale

    #
    self.dorianscale          = WestTemp.get_nseqby_seqpos(
                                  [0, 2, 3, 5, 7, 9, 10], NSEQ_SCALE)
    # assert_equal self.west_temp, WestTemp
    self.locrianscale         = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 5, 6, 8, 10], NSEQ_SCALE)
    # assert_equal self.west_temp, WestTemp
    self.superlocrianscale    = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 4, 6, 8, 10], NSEQ_SCALE)
    # assert_equal self.west_temp, WestTemp
    self.ultralocrianscale    = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 4, 6, 8, 9], NSEQ_SCALE)
    # assert_equal self.west_temp, WestTemp
    self.dubflat7locrianscale = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 5, 6, 8, 9], NSEQ_SCALE)
    # assert_equal self.west_temp, WestTemp

    #
    self.majorchord = NoteSeq.new("TestMajor", NSEQ_SCALE, WestTemp,
                                  [0, 4, 7], [0, 2, 4])
    # assert_equal self.west_temp, WestTemp

  end

  def teardown
  end

end


#
#
#
class MusicSetTheory::NoteSeq_ScalesTest

  # Like test_seq_dict, but checks dictionary in WestTemp.
  test "temperament_dict" do
    #
    #
    #
    # wt = WestTemp
    #wt = self.west_temp
    wt = self.west_temp
    assert_equal self.west_temp, wt

    #
    assert_true wt.check_nseqby_subdict(NSEQ_CHORD)
    assert_true wt.check_nseqby_subdict(NSEQ_SCALE)
    assert_false wt.check_nseqby_subdict(666)
    assert_true wt.check_nseqby_name(NSEQ_SCALE, "Major")
    assert_false wt.check_nseqby_name(NSEQ_CHORD, "Minor")
    assert_false wt.check_nseqby_name(NSEQ_SCALE, "Minor")
    assert_false wt.check_nseqby_abbrv(NSEQ_SCALE, "maj")
    assert_false wt.check_nseqby_abbrv(NSEQ_CHORD, "min")
    assert_false wt.check_nseqby_abbrv(NSEQ_SCALE, "min")
    assert_false wt.check_nseqby_seqpos(NSEQ_CHORD, CHROM_NAT_NOTE_POS)
    assert_true wt.check_nseqby_seqpos(NSEQ_SCALE, CHROM_NAT_NOTE_POS)

    assert_equal self.majorscale, wt.get_nseqby_name("Major", NSEQ_SCALE)
    assert_equal self.majorscale, wt.get_nseqby_name("Ionian", NSEQ_SCALE)

    assert_equal self.melminscale,
      wt.get_nseqby_name("Melodic Minor", NSEQ_SCALE)
    assert_equal self.melminscale,
       wt.get_nseqby_name("Jazz Minor", NSEQ_SCALE)
    assert_equal self.harmminscale,
      wt.get_nseqby_name("Harmonic Minor", NSEQ_SCALE)
    assert_equal self.harmmajscale,
      wt.get_nseqby_name("Harmonic Major", NSEQ_SCALE)
    assert_equal self.dorianscale,
      wt.get_nseqby_name("Dorian", NSEQ_SCALE)
    assert_equal self.locrianscale,
      wt.get_nseqby_name("Locrian", NSEQ_SCALE)
    assert_equal self.superlocrianscale,
      wt.get_nseqby_name("Superlocrian", NSEQ_SCALE)
    assert_equal self.ultralocrianscale,
      wt.get_nseqby_name("Ultralocrian", NSEQ_SCALE)
    assert_equal self.dubflat7locrianscale,
      wt.get_nseqby_name("Locrian " + M_FLAT + M_FLAT + "7", NSEQ_SCALE)

    #
    assert_equal self.majorscale,
      wt.get_nseqby_seqpos(CHROM_NAT_NOTE_POS, NSEQ_SCALE)

    #
    assert_equal self.melminscale,
      wt.get_nseqby_seqpos(MEL_MIN_NOTE_POS, NSEQ_SCALE)
    assert_equal self.harmminscale,
      wt.get_nseqby_seqpos(HARM_MIN_NOTE_POS, NSEQ_SCALE)
    assert_equal self.harmmajscale,
      wt.get_nseqby_seqpos(HARM_MAJ_NOTE_POS, NSEQ_SCALE)

  end

  test "get_notes_for_key" do
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
    assert_equal ["B\u266d", "E\u266d"],
      self.majorchord.get_notes_for_key("Eb", 2, [0, 1])
    assert_equal ["E\u266d", "G"],
      self.majorchord.get_notes_for_key("Eb", 3, [0, 1])
    assert_equal ["F", "G", "A", "B"],
      self.majorscale.get_notes_for_key("C", 3, [0, 1, 2, 3])
  end

  test "get_posn_for_offset" do
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
    assert_equal [0, 4, 7],
      self.majorscale.get_posn_for_offset(0, [0, 2, 4], raz: true)
    assert_equal [0, 3, 7],
      self.majorscale.get_posn_for_offset(1, [0, 2, 4], raz: true)
    assert_equal [0, 4, 7],
      self.majorscale.get_posn_for_offset(3, [0, 2, 4], raz: true)
    assert_equal [0, 4, 7],
      self.majorscale.get_posn_for_offset(4, [0, 2, 4], raz: true)
    assert_equal [0, 3, 6],
      self.majorscale.get_posn_for_offset(6, [0, 2, 4], raz: true)

  end

end


#
#
#
class MusicSetTheory::NoteSeq_ScalesTest

  test "NoteSeq_Scales  - scales" do

    ret = MusicSetTheory.scales.sort
    exp = [
      :MajorScale,
      :MelMinorScale,
      :HarmMinorScale,
      :HarmMajorScale,
      :DiscMinorScale,
      :HungarianScale,
      :MajorPentaScale,
      :MinorPentaScale,
      :RyukyuPentaScale,
      :BluesHexaScale,
    ].sort
    assert_equal exp, ret

    #
    MusicSetTheory.undef_scale(:MajorPentaScale)
    ret = MusicSetTheory.scales.sort
    exp = [
      :MajorScale,
      :MelMinorScale,
      :HarmMinorScale,
      :HarmMajorScale,
      :DiscMinorScale,
      :HungarianScale,
      # :MajorPentaScale,
      :MinorPentaScale,
      :RyukyuPentaScale,
      :BluesHexaScale,
    ].sort
    assert_equal exp, ret

  end

end


#### endof filename: test/scales_test.rb
