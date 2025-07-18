# frozen_string_literal: true
#
# filename: test/temperament_test.rb
#

require "test_helper"


#
#
#
class MusicSetTheory::TemperamentTest < Test::Unit::TestCase
  attr_accessor :chromabsrep
  attr_accessor :chrom_as_sharp
  attr_accessor :chrom_as_flat
  attr_accessor :triad_pattern
  attr_accessor :major_interval

  attr_accessor :ourseqdict
  attr_accessor :majorchord
  attr_accessor :majorscale
  attr_accessor :seq_maps

  attr_accessor :west_temp
  def self.startup;   end
  def self.shutdown;  end

  #
  include MusicSetTheory::Temperament
  include MusicSetTheory

  #
  def setup
    self.chromabsrep    = [
      "C",  "C" + M_SHARP, "D", "E" + M_FLAT, "E", "F", "F" + M_SHARP,
      "G",  "A" + M_FLAT,  "A", "B" + M_FLAT, "B"+M_NATURAL, ]
    self.chrom_as_sharp = [
      "C", "C" + M_SHARP, "D", "D" + M_SHARP, "E", "F", "F" + M_SHARP,
      "G", "G" + M_SHARP, "A", "A" + M_SHARP, "B", ]
    self.chrom_as_flat = [
      "C", "D" + M_FLAT, "D", "E" + M_FLAT, "E", "F", "G" + M_FLAT,
      "G", "A" + M_FLAT, "A", "B" + M_FLAT, "B", ]

    #
    self.triad_pattern  = [0, 2, 4]
    self.major_interval = [0, 4, 7]

    #
    self.ourseqdict = SeqDict.new([NSEQ_SCALE, NSEQ_CHORD], WestTemp)
    self.majorchord = ["Major", "maj", self.major_interval]
    self.majorscale = ["Major", [], CHROM_NAT_NOTE_POS]

    #
    self.seq_maps   = SeqDict.new([NSEQ_SCALE, NSEQ_CHORD], WestTemp)
    self.seq_maps.add_elem(self.majorchord, NSEQ_CHORD, "Major", "maj",
      self.major_interval)
    self.seq_maps.add_elem(self.majorscale, NSEQ_SCALE, "Major", [],
            CHROM_NAT_NOTE_POS)

    # for the dependancy of the state...
    #
    #
    # self.west_temp = WestTemp.deep_dup
    self.west_temp = MusicSetTheory::Temperament.WestTempNew()

  end

  def teardown
    # Temperament.WestTempReset()
  end

end


#
#
#
class MusicSetTheory::TemperamentTest

  test "init" do
    # wt = WestTemp
    wt = self.west_temp

    #
    assert_equal CHROM_SIZE, wt.no_keys
    assert_equal 7, wt.no_nat_keys
    assert_equal CHROM_NAT_NOTES, wt.nat_keys
    assert_equal CHROM_NAT_NOTE_POS, wt.nat_key_posn

    for i in 0...7
      note_desired  = CHROM_NAT_NOTES[i]
      note_index    = wt.nat_key_pos_lookup[note_desired]

      assert_equal note_desired, wt.pos_lookup_nat_key[note_index]
    end

  end

  test "get_pos_of_key" do
    # wt = WestTemp
    wt = self.west_temp

    # add tests for RE_NOTEPARSE.
    tmp = RE_NOTEPARSE.match("C#")
    ret = tmp[:basenotename].chars
    exp = ["C", "#"]
    assert_equal exp, ret

    tmp = RE_NOTEPARSE.match("C\u266f")
    ret = tmp[:basenotename].chars
    exp = ["C", "\u266f"]
    assert_equal exp, ret

    #
    for i in 0...CHROM_SIZE
      # $stderr.puts "i: #{i}, chrom: #{self.chromabsrep[i]}"
      assert_equal i, wt.get_pos_of_key(self.chromabsrep[i])
    end
  end

  test "get_key_of_pos" do
    # wt = WestTemp
    wt = self.west_temp

    for i in 0...CHROM_SIZE
      assert_equal self.chrom_as_sharp[i],
        wt.get_key_of_pos(i, nil, true)
      assert_equal self.chrom_as_flat[i],
        wt.get_key_of_pos(i, nil, false)
      #
      if i < 6
        assert_equal "C" + (M_SHARP * i),
          wt.get_key_of_pos(i, "C", false)
        assert_equal "B" + (M_SHARP * (i + 1)),
          wt.get_key_of_pos(i, "B", false)
      elsif i == 6
        assert_equal "C" + (M_SHARP * 6),
          wt.get_key_of_pos(i, "C", false)
        assert_equal "B" + (M_FLAT * 5),
          wt.get_key_of_pos(i, "B", false)
      else
        assert_equal "C" + (M_FLAT * (12 - i)),
          wt.get_key_of_pos(i, "C", false)
        assert_equal "B" + (M_FLAT * (11 - i)),
          wt.get_key_of_pos(i, "B", false)
      end
    end

  end

  test "get_note_sequence" do
    # wt = WestTemp
    wt = self.west_temp

    assert_equal ["C", "E", "G"],
      wt.get_note_sequence("C", self.major_interval, nil, false)
    assert_equal ["C", "E", "G"],
      wt.get_note_sequence("C", self.major_interval, nil, true)
    assert_equal ["C", "E", "G"],
      wt.get_note_sequence(
        "C", self.major_interval, self.triad_pattern, true)
    assert_equal ["D" + M_FLAT, "F", "A" + M_FLAT],
      wt.get_note_sequence("C#", self.major_interval, nil, false)
    assert_equal ["C" + M_SHARP, "F", "G" + M_SHARP],
      wt.get_note_sequence("C#", self.major_interval, nil, true)
    assert_equal ["C" + M_SHARP, "E" + M_SHARP, "G" + M_SHARP],
      wt.get_note_sequence(
        "C#", self.major_interval, self.triad_pattern, true)
    assert_equal ["D" + M_FLAT, "F", "A" + M_FLAT],
      wt.get_note_sequence("Db", self.major_interval, nil, false)
    assert_equal ["C" + M_SHARP, "F", "G" + M_SHARP],
      wt.get_note_sequence("Db", self.major_interval, nil, true)
    assert_equal ["D" + M_FLAT, "F", "A" + M_FLAT],
      wt.get_note_sequence(
        "Db", self.major_interval, self.triad_pattern, true)
  end

  test "get_keyseq_notes" do
    # wt = WestTemp
    wt = self.west_temp

    assert_equal ["C", [0, 4, 7]], wt.get_keyseq_notes(["C", "E", "G"])
    assert_equal ["C" + M_SHARP, [0, 4, 7]],
      wt.get_keyseq_notes(["C" + M_SHARP, "F", "A" + M_FLAT])
    assert_equal ["D" + M_FLAT, [0, 4, 7]],
      wt.get_keyseq_notes(["D" + M_FLAT, "F", "A" + M_FLAT])
  end

  # Fits all testing for the seq_dict class in here.
  test "SeqDict" do
    assert_true self.seq_maps.check_nseqby_subdict(NSEQ_CHORD)
    assert_true self.seq_maps.check_nseqby_subdict(NSEQ_SCALE)
    assert_false self.seq_maps.check_nseqby_subdict(666)
    assert_true self.seq_maps.check_nseqby_name(NSEQ_CHORD, "Major")
    assert_true self.seq_maps.check_nseqby_name(NSEQ_SCALE, "Major")
    assert_false self.seq_maps.check_nseqby_name(NSEQ_CHORD, "Minor")
    assert_false self.seq_maps.check_nseqby_name(NSEQ_SCALE, "Minor")
    assert_true self.seq_maps.check_nseqby_abbrv(NSEQ_CHORD, "maj")
    assert_false self.seq_maps.check_nseqby_abbrv(NSEQ_SCALE, "maj")
    assert_false self.seq_maps.check_nseqby_abbrv(NSEQ_CHORD, "min")
    assert_false self.seq_maps.check_nseqby_abbrv(NSEQ_SCALE, "min")
    assert_false self.seq_maps.check_nseqby_seqpos(NSEQ_CHORD,
                                                   CHROM_NAT_NOTE_POS)
    assert_true self.seq_maps.check_nseqby_seqpos(NSEQ_SCALE,
                                                  CHROM_NAT_NOTE_POS)
    assert_true self.seq_maps.check_nseqby_seqpos(NSEQ_CHORD,
                                                  self.major_interval)
    assert_false self.seq_maps.check_nseqby_seqpos(NSEQ_SCALE,
                                                   self.major_interval)

    #
    assert_equal self.majorchord,
      self.seq_maps.get_nseqby_name("Major", NSEQ_CHORD)
    assert_equal self.majorscale,
      self.seq_maps.get_nseqby_name("Major", NSEQ_SCALE)
    assert_equal self.majorchord,
      self.seq_maps.get_nseqby_abbrv("maj", NSEQ_CHORD)
    assert_equal self.majorchord,
      self.seq_maps.get_nseqby_seqpos(self.major_interval, NSEQ_CHORD)
    assert_equal self.majorscale,
      self.seq_maps.get_nseqby_seqpos(CHROM_NAT_NOTE_POS, NSEQ_SCALE)
  end

  # Like test_seq_dict, but checks dictionary in WestTemp.
  test "temperament_dict" do
    # wt = WestTemp
    wt = self.west_temp

    #
    assert_true wt.check_nseqby_subdict(NSEQ_CHORD)
    assert_true wt.check_nseqby_subdict(NSEQ_SCALE)
    assert_false wt.check_nseqby_subdict(666)

    #
    wt.add_elem(self.majorchord, NSEQ_CHORD, "Major", "maj",
      self.major_interval)
    wt.add_elem(self.majorscale, NSEQ_SCALE, "Major", [],
      CHROM_NAT_NOTE_POS)
    assert_true wt.check_nseqby_name(NSEQ_CHORD, "Major")
    assert_true wt.check_nseqby_name(NSEQ_SCALE, "Major")
    assert_false wt.check_nseqby_name(NSEQ_CHORD, "Minor")
    assert_false wt.check_nseqby_name(NSEQ_SCALE, "Minor")
    assert_true wt.check_nseqby_abbrv(NSEQ_CHORD, "maj")
    assert_false wt.check_nseqby_abbrv(NSEQ_SCALE, "maj")
    assert_false wt.check_nseqby_abbrv(NSEQ_CHORD, "min")
    assert_false wt.check_nseqby_abbrv(NSEQ_SCALE, "min")
    assert_false wt.check_nseqby_seqpos(NSEQ_CHORD,
                                        CHROM_NAT_NOTE_POS)
    assert_true wt.check_nseqby_seqpos(NSEQ_SCALE,
                                       CHROM_NAT_NOTE_POS)
    assert_true wt.check_nseqby_seqpos(NSEQ_CHORD,
                                       self.major_interval)

    #
    assert_equal self.majorchord,
      wt.get_nseqby_name("Major", NSEQ_CHORD)
    assert_equal self.majorscale,
      wt.get_nseqby_name("Major", NSEQ_SCALE)
    assert_equal self.majorchord,
      wt.get_nseqby_abbrv("maj", NSEQ_CHORD)
    assert_equal self.majorchord,
      wt.get_nseqby_seqpos(self.major_interval, NSEQ_CHORD)
    assert_equal self.majorscale,
      wt.get_nseqby_seqpos(CHROM_NAT_NOTE_POS, NSEQ_SCALE)
  end

end


#### endof filename: test/temperament_test.rb
