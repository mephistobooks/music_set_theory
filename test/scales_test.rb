# frozen_string_literal: true
#
# filename: test/scales_test.rb
#

require "test_helper"


# This tests the note_seq and scales class.
#
#
class MusicTheory::NoteSeq_ScalesTest < Test::Unit::TestCase

  #
  def self.startup;   end
  def self.shutdown;  end

  #
  include MusicTheory::Temperament
  include MusicTheory

  #
  attr_accessor :majorscale, :melminscale, :harmminscale
  attr_accessor :harmmajscale, :dorianscale
  attr_accessor :locrianscale, :superlocrianscale, :ultralocrianscale
  attr_accessor :dubflat7locrianscale
  attr_accessor :majorchord
  def setup
    self.majorscale   = MajorScale
    self.melminscale  = MelMinorScale
    self.harmminscale = HarmMinorScale
    self.harmmajscale = HarmMajorScale

    #
    self.dorianscale          = WestTemp.get_nseqby_seqpos(
                                  [0, 2, 3, 5, 7, 9, 10], NSEQ_SCALE)
    self.locrianscale         = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 5, 6, 8, 10], NSEQ_SCALE)
    self.superlocrianscale    = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 4, 6, 8, 10], NSEQ_SCALE)
    self.ultralocrianscale    = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 4, 6, 8, 9], NSEQ_SCALE)
    self.dubflat7locrianscale = WestTemp.get_nseqby_seqpos(
                                  [0, 1, 3, 5, 6, 8, 9], NSEQ_SCALE)

    #
    self.majorchord = NoteSeq.new("TestMajor", NSEQ_SCALE, WestTemp,
                                  [0, 4, 7], [0, 2, 4])
  end

  def teardown
  end

end


#
#
#
class MusicTheory::NoteSeq_ScalesTest

  # Like test_seq_dict, but checks dictionary in WestTemp.
  test "temperament_dict" do

    #
    assert_true WestTemp.check_nseqby_subdict(NSEQ_CHORD)
    assert_true WestTemp.check_nseqby_subdict(NSEQ_SCALE)
    assert_false WestTemp.check_nseqby_subdict(666)
    assert_true WestTemp.check_nseqby_name(NSEQ_SCALE, "Major")
    assert_false WestTemp.check_nseqby_name(NSEQ_CHORD, "Minor")
    assert_false WestTemp.check_nseqby_name(NSEQ_SCALE, "Minor")
    assert_false WestTemp.check_nseqby_abbrv(NSEQ_SCALE, "maj")
    assert_false WestTemp.check_nseqby_abbrv(NSEQ_CHORD, "min")
    assert_false WestTemp.check_nseqby_abbrv(NSEQ_SCALE, "min")
    assert_false WestTemp.check_nseqby_seqpos(NSEQ_CHORD, CHROM_NAT_NOTE_POS)
    assert_true WestTemp.check_nseqby_seqpos(NSEQ_SCALE, CHROM_NAT_NOTE_POS)

    assert_equal self.majorscale, WestTemp.get_nseqby_name("Major", NSEQ_SCALE)
    assert_equal self.majorscale, WestTemp.get_nseqby_name("Ionian", NSEQ_SCALE)

    assert_equal self.melminscale,
      WestTemp.get_nseqby_name("Melodic Minor", NSEQ_SCALE)
    assert_equal self.melminscale,
       WestTemp.get_nseqby_name("Jazz Minor", NSEQ_SCALE)
    assert_equal self.harmminscale,
      WestTemp.get_nseqby_name("Harmonic Minor", NSEQ_SCALE)
    assert_equal self.harmmajscale,
      WestTemp.get_nseqby_name("Harmonic Major", NSEQ_SCALE)
    assert_equal self.dorianscale,
      WestTemp.get_nseqby_name("Dorian", NSEQ_SCALE)
    assert_equal self.locrianscale,
      WestTemp.get_nseqby_name("Locrian", NSEQ_SCALE)
    assert_equal self.superlocrianscale,
      WestTemp.get_nseqby_name("Superlocrian", NSEQ_SCALE)
    assert_equal self.ultralocrianscale,
      WestTemp.get_nseqby_name("Ultralocrian", NSEQ_SCALE)
    assert_equal self.dubflat7locrianscale,
      WestTemp.get_nseqby_name("Locrian " + M_FLAT + M_FLAT + "7", NSEQ_SCALE)

    #
    assert_equal self.majorscale,
      WestTemp.get_nseqby_seqpos(CHROM_NAT_NOTE_POS, NSEQ_SCALE)

    #
    assert_equal self.melminscale,
      WestTemp.get_nseqby_seqpos(MEL_MIN_NOTE_POS, NSEQ_SCALE)
    assert_equal self.harmminscale,
      WestTemp.get_nseqby_seqpos(HARM_MIN_NOTE_POS, NSEQ_SCALE)
    assert_equal self.harmmajscale,
      WestTemp.get_nseqby_seqpos(HARM_MAJ_NOTE_POS, NSEQ_SCALE)

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


#### endof filename: test/scales_test.rb
