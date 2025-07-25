# frozen_string_literal: true
#
# filename: music_set_theory/scale.rb
#


#-*- coding: UTF-8 -*-
# scales.py: Defines the classes for note sequences and scales.
#
# Copyright (c) 2008-2020 Peter Murphy <peterkmurphy@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * The names of its contributors may not be used to endorse or promote 
#       products derived from this software without specific prior written 
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTORS ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# import unittest;
# 
# from .musutility import rotate, rotate_and_zero, multislice;
# from .temperament import temperament, WestTemp, seq_dict, NSEQ_SCALE, \
#     NSEQ_CHORD, M_SHARP, M_FLAT, CHROM_NAT_NOTE_POS;
# 
require_relative "./musutility"
require_relative "./temperament"


#
#
#
# This represents a pattern of notes - a scale or a chord - each with a
# specified position from a base key or note. For example, a major scale
# is specified as the pattern [0, 2, 4, 5, 7, 9, 11], while a major chord
# is specified as [0, 4, 7].[*] In each case, we don't specify the key.
# However, this class provides functions that allow users to generate
# notes with a specified key as a function argument.
#
# [* If this doesn't make sense, consider the first note of a major scale
# is 0 semitones from the first note of a major scale, the second note is
# 2 semitones (a tone) from the first note, the third note is 4 semitones
# from the first note... and so on to the final note of the scale, which
# is 11 tones from the first note. Exercise for the reader: try this
# concept with a _major_ chord. ]
# 
module MusicSetTheory

  class NoteSeq
    include Temperament
    include MusUtility
  end
  class NoteSeqScale < NoteSeq
    #include MusUtility
  end

end


#
#
#
module MusicSetTheory
  class NoteSeq

    #
    # Initialiser. It contains the following arguments.
    # ==== Args
    # nseq_name:: the full name of the note sequence.
    # nseq_type:: the type of note sequence (e.g., NSEQ_SCALE or NSEQ_CHORD).
    # nseq_temp:: the musical temperament from which the sequence of notes is
    #   taken. This should be an instance of the class temperament.
    # nseq_posn:: a sequence of integers representing positions of the notes
    #   in the sequence relative to its first note. (For best results,
    #   the first item should be 0 to represent the first note.) 
    # nseq_nat_posns:: a sequence of integers (which should be the same size
    #   as nseq_posn). For each item in nseq_posn, the corresponding item
    #   in nseq_nat_posns represent the difference in its calculated 
    #   natural note from the base key's natural note. For example, this
    #   parameter is [0, 2, 4] for a major chord; the second note is always
    #   two letters higher than the first note, and the third note is two
    #   letters higher again.
    #   (! this is in degrees.)
    # nseq_abbrv:: the primary abbreviation for the note sequence (if any).
    # nseq_synonyms:: a list of possible synonyms, or extra names, for the 
    #   note sequence. For example, the "Ionian" mode is another name for
    #   the major scale as far as this class is concerned.
    # nseq_other_abbrevs:: a list of possible alternate abbreviations for the
    #   note sequence. For example, both "min7" and "m7" are abbreviations
    #   for the minor seventh chord.
    #
    # ==== Examples of defining scales:
    # Major scale:: NoteSeq.new("Major", NSEQ_SCALE, WestTemp, [0, 2, 4, 5, 7,
    #   9, 11], range(7), nseq_synonyms: ["Ionian"])
    # Harmonic Minor scale:: NoteSeq.new("Harmonic Minor", NSEQ_SCALE, WestTemp,
    #   [0, 2, 3, 5, 7, 8, 11], 0...7);
    #
    # Examples of defining chords:
    # Major chord: noteseq("Major", NSEQ_CHORD, WestTemp, [0, 4, 7], 
    #   [0, 2, 4], "maj");
    # Minor chord: noteseq("Minor", NSEQ_CHORD, WestTemp, 
    #   [0, 3, 7], [0, 2, 4], "min", nseq_other_abbrevs = ["m"]);
    # Min 7 chord: noteseq("Minor Seventh", NSEQ_CHORD, WestTemp, 
    #   [0, 3, 7, 11], [0, 2, 4, 6], "min7", nseq_other_abbrevs = ["m7"]);
    #
    # Note: it is easier to define scales using the noteseq_scale class (this
    # file) and chord using the noteseq_chord class (in chords.py)
    #
    # ==== Warning
    # - ! This method updates `nseq_temp`.
    #
    attr_accessor :nseq_name, :nseq_type, :nseq_temp, :nseq_posn
    attr_accessor :nseq_nat_posns, :nseq_abbrev, :nseq_synonyms,
                  :nseq_other_abbrevs
    def initialize( nseq_name, nseq_type, nseq_temp, nseq_posn,
                    nseq_nat_posns,
                    # nseq_abbrev = "", nseq_synonyms = [],
                    # nseq_other_abbrevs = [] )
                    nseq_abbrev: "", nseq_synonyms: [],
                    nseq_other_abbrevs: [] )
      self.nseq_name = nseq_name
      self.nseq_type = nseq_type

      self.nseq_temp = nseq_temp
      # self.nseq_temp = deep_melt(nseq_temp.deep_dup)

      self.nseq_posn = nseq_posn

      self.nseq_nat_posns     = nseq_nat_posns
      self.nseq_abbrev        = nseq_abbrev
      self.nseq_synonyms      = nseq_synonyms
      self.nseq_other_abbrevs = nseq_other_abbrevs

      #
      self.register_with_temp(self.nseq_temp)
    end

    #
    # alias name        nseq_name
    # alias type        nseq_type
    # alias temperament nseq_temp
    # alias tment       nseq_temp   # *
    #  :
    # etc.
    {
      nseq_name:            [:name],
      nseq_type:            [:type],
      nseq_temp:            [:temp, :temperament,  :tment],
      nseq_posn:            [:posn, :note_pos,     :notes],
      nseq_nat_posns:       [:nat_posns, :note_nat, :notes_degree,
                             :notes_deg],
      nseq_abbrev:          [:abbrev,   :abbr],
      nseq_synonyms:        [:synonyms, :syns],
      nseq_other_abbrevs:   [:other_abbrevs, :abbr_others],
    }.each do |k, vary|

      vary.each do |new_name|
        getter_name = k
        setter_name = k.to_s + "="
        if method_defined? getter_name
          new_getter_name = new_name
          alias_method new_getter_name, getter_name
        end
        if method_defined? setter_name
          new_setter_name = new_name.to_s + "="
          alias_method new_setter_name, setter_name
        end
      end

    end

  end
end


#
#
#
module MusicSetTheory
  class NoteSeq

    # Registers this note sequence with the underlying temperament, so
    # that it can be looked up by name, by abbreviation or by sequence.
    # ==== Warning
    # - This methods updates `self.nseq_temp`
    #
    def register_with_temp( nseq_temp = self.nseq_temp )
      if self.nseq_synonyms
        #if self.nseq_name not in self.nseq_synonyms
        if !(self.nseq_synonyms.include? self.nseq_name)
          our_names = [self.nseq_name] + self.nseq_synonyms;
        else
          our_names = self.nseq_synonyms;
        end
      else
        our_names = [self.nseq_name];
      end

      if self.nseq_other_abbrevs
        #if self.nseq_abbrev not in self.nseq_other_abbrevs
        if !(self.nseq_other_abbrevs.include? self.nseq_abbrev)
          our_abbrevs = [self.nseq_abbrev] + self.nseq_other_abbrevs
        else
          our_abbrevs = self.nseq_other_abbrevs
        end
      else
        our_abbrevs = [self.nseq_abbrev]
      end

      #
      nseq_temp.seq_maps.add_elem(
        self, self.nseq_type, our_names, our_abbrevs, self.nseq_posn)
    end

    # Get the notes for the note_seq starting from a given key. Then
    # rotates the sequence (by rotate_by). Then slices it (using the
    # argument in the slice parameter).
    #
    def get_notes_for_key( key, rotate_by=0, slice=nil )
      ret = nil
      default_seq = self.nseq_temp.get_note_sequence(
                      key, self.nseq_posn, self.nseq_nat_posns); #C
      modulus = self.nseq_temp.no_nat_keys
      if slice
        ret = multislice(
                default_seq, slice, offset: rotate_by, mod: modulus);
      else
        ret = rotate(default_seq, rotate_by);
      end
      ret
    end

    # For this noteseq, output its positions relative to its first
    # note, then rotates the sequence (by rotate_by), then slices
    # it (using slice, if not none). If and only if raz is True, the
    # result is rotated-and-zeroed.
    #
    def get_posn_for_offset( rotate_by=0, slice=nil, raz: false )
      if slice
        modulus = self.nseq_temp.no_nat_keys
        multisliced = multislice(
                        self.nseq_posn, slice,
                        offset: rotate_by, mod: modulus)
        if raz
          return rotate_and_zero(multisliced, 0, self.nseq_temp.no_keys);
        else
          return multisliced;
        end
      else
        if raz
          return rotate_and_zero(
            self.nseq_posn, rotate_by, self.nseq_temp.no_keys)
        else
          return rotate(self.nseq_posn, rotate_by)
        end
      end
    end


  end
end


# FIXME. separate the file.
#
#
# A specialisation of noteseq used exclusively for defining scales -
# especially heptatonic/diotonic scales.
#
module MusicSetTheory
  class NoteSeqScale

    #
    # ==== Args
    # nseq_name:: name of scale.
    # nseq_temp:: temperament for scale.
    # nseq_posn:: position of notes in scale.
    # nseq_nat_posns:: natural note positions for notes in scales.
    # nseq_modes:: a sequence of modes for the scale, listed in order of
    #   position.
    #
    def initialize( nseq_name, nseq_temp, nseq_posn, nseq_nat_posns,
                    nseq_modes = [], debug_f: false )
      #
      return super(
        nseq_name, NSEQ_SCALE, nseq_temp, nseq_posn, nseq_nat_posns
      ) if nseq_modes.empty?

      ###
      super(nseq_name, NSEQ_SCALE, nseq_temp, nseq_posn, nseq_nat_posns,
            nseq_abbrev: "", nseq_synonyms: [nseq_modes[0]])

      new_nseq_pos      = nseq_posn
      new_nseq_nat_pos  = nseq_nat_posns

      # This creates more instances of noteseq_scales - all for the different
      # modes.
      # By creating them, they will be automatically connected to the
      # appropriate temperament's dictionary.
      for i in 1...nseq_posn.size
        $stderr.puts "{#{__method__}} new_nseq_pos: #{new_nseq_pos.inspect}," +
          " new_nseq_nat_pos: #{new_nseq_nat_pos.inspect}" if debug_f

        new_nseq_pos     = rotate_and_zero(new_nseq_pos, 1, nseq_temp.no_keys)
        new_nseq_nat_pos = rotate_and_zero(new_nseq_nat_pos, 1,
                             nseq_temp.no_nat_keys)

        # create an other scale.
        NoteSeqScale.new(
          nseq_modes[i], nseq_temp, new_nseq_pos, new_nseq_nat_pos)
      end
    end

    def to_s
      self.nseq_name.to_s
    end

  end
end


module MusicSetTheory

  #
  include Temperament

  # The following scales and names are derived from:
  # http://docs.solfege.org/3.9/C/scales/modes.html

  # The only exception is the "Discordant Minor", which I invented for
  # shit and giggles.

  # Note: MelMinScale represents a melodic minor scale _ascending_. See the
  # Aeolian mode of the Major scale for melodic minor scale _descending_.

  HEPT_NAT_POSNS = (0...7).to_a
  MEL_MIN_NOTE_POS    = [0, 2, 3, 5, 7, 9, 11]
  HARM_MIN_NOTE_POS   = [0, 2, 3, 5, 7, 8, 11]
  HARM_MAJ_NOTE_POS   = [0, 2, 4, 5, 7, 8, 11]
  DISC_MIN_NOTE_POS   = [0, 2, 3, 5, 6, 9, 11]
  HUNGARIAN_NOTE_POS  = [0, 3, 4, 6, 7, 9, 10]


  # For ease of comprehension, we have the list of modes as arrays which 
  # can be browsed from outside.
  MAJOR_MODES = [ "Ionian",
    "Dorian",
    "Phrygian",
    "Lydian",
    "Mixolydian",
    "Aeolian",
    "Locrian", ]
  MAJORMODES = MAJOR_MODES

  MEL_MINOR_MODES = [ "Jazz Minor",
    "Dorian " + M_FLAT + "9",
    "Lydian Augmented",
    "Lydian Dominant",
    "Mixolydian " + M_FLAT + "13",
    "Semilocrian",
    "Superlocrian", ]
  MELMINORMODES = MEL_MINOR_MODES

  HARM_MINOR_MODES = [ "Harmonic Minor",
    "Locrian " + M_SHARP + "6",
    "Ionian Augmented",
    "Romanian",
    "Phrygian Dominant",
    "Lydian " + M_SHARP + "2",
    "Ultralocrian", ]
  HARMINORMODES  = HARM_MINOR_MODES  # for compatibility... typo?

  HARM_MAJOR_MODES = [ "Harmonic Major",
    "Dorian " + M_FLAT + "6",
    "Phrygian " + M_FLAT + "4",
    "Lydian " + M_FLAT + "3",
    "Mixolydian " + M_FLAT + "9",
    "Lydian " + M_SHARP + "2 " + M_SHARP + "5",
    "Locrian " + M_FLAT + M_FLAT + "7", ]
  HARMMAJORMODES = HARM_MAJOR_MODES

  DISCORD_MIN_MODES = [ "Melodic Minor " + M_FLAT + "5",
    "Dorian " + M_FLAT + "9 " + M_FLAT + "4",
    "Minor Lydian Augmented",
    "Lydian Dominant " + M_FLAT + "9",
    "Lydian Augmented " + M_SHARP + "2 " + M_SHARP + "3",
    "Semilocrian " + M_FLAT + M_FLAT + "7",
    "Superlocrian " + M_FLAT + M_FLAT + "6", ]
  DISCORDMINMODES = DISCORD_MIN_MODES

  HUNGARIAN_MODES = [ "Hungarian",
    "Superlocrian " + M_FLAT + M_FLAT + "6 " + M_FLAT + M_FLAT + "7",
    "Harmonic Minor " + M_FLAT + "5",
    "Superlocrian " + M_SHARP + "6",
    "Melodic Minor " + M_SHARP + "5",
    "Dorian " + M_FLAT + "9 " + M_SHARP + "11",
    "Lydian Augmented " + M_SHARP + "3", ]
  HUNGARIANMODES = HUNGARIAN_MODES

  MODE_ARRAY = [
    MAJOR_MODES,
    MEL_MINOR_MODES,
    HARM_MINOR_MODES,
    HARM_MAJOR_MODES,
    DISCORD_MIN_MODES,
    HUNGARIAN_MODES,
  ]
end

module MusicSetTheory

  #
  #
  #
  Pentatonic_NAT_POSNS = (0...5).to_a     # 5音音階
  Hexatonic_NAT_POSNS  = (0...6).to_a     # 6音音階
  Heptatonic_NAT_POSNS = HEPT_NAT_POSNS   # 7音音階
  Octatonic_NAT_POSNS  = (0...8).to_a     # 8音音階

  # Pentatonic.
  #
  #
  MAJOR_PENTA_NOTE_POS  = [ 0, 2, 4, 7,  9, ]
  MINOR_PENTA_NOTE_POS  = [ 0, 3, 5, 7, 10, ]
  RYUKYU_PENTA_NOTE_POS = [ 0, 4, 5, 7, 11, ]

  BLUES_HEXA_NOTE_POS   = [ 0, 3, 5, 6, 7, 10, ]

  def self.def_scale( const_name, name: , tment: ,
                      note_pos: , modes: [],
                      scale_array: :ScaleArray )
    posns = (0...(note_pos.size)).to_a

    tmp = NoteSeqScale.new(name, tment, note_pos, posns, modes)
    self.const_set(const_name, tmp)
    ret = self.const_get(const_name)

    self.const_get(scale_array).const_set(const_name,ret)

    ret
  end

  def self.undef_scale( const_name, scale_array: :ScaleArray )
    self.const_get(scale_array).send(:remove_const, const_name)
    self.send(:remove_const, const_name)
  end

  def self.scales( scale_array: :ScaleArray )
    self.const_get(scale_array).constants
  end

end


# Scales.
#
#
module MusicSetTheory
  #ScaleArray = []
  module ScaleArray; end

  #MajorScale     = NoteSeqScale.new("Major", WestTemp,
  #                   CHROM_NAT_NOTE_POS, HEPT_NAT_POSNS, MAJORMODES)
  #MelMinorScale  = NoteSeqScale.new("Melodic Minor", WestTemp,
  #                   MEL_MIN_NOTE_POS, HEPT_NAT_POSNS, MELMINORMODES)
  #HarmMinorScale = NoteSeqScale.new("Harmonic Minor", WestTemp,
  #                   HARM_MIN_NOTE_POS, HEPT_NAT_POSNS, HARMINORMODES)
  #HarmMajorScale = NoteSeqScale.new("Harmonic Major", WestTemp,
  #                   HARM_MAJ_NOTE_POS, HEPT_NAT_POSNS, HARMMAJORMODES)
  #DiscMinorScale = NoteSeqScale.new("Discordant Minor", WestTemp,
  #                   DISC_MIN_NOTE_POS, HEPT_NAT_POSNS, DISCORDMINMODES)
  #HungarianScale = NoteSeqScale.new("Hungarian", WestTemp,
  #                   HUNGARIAN_NOTE_POS, HEPT_NAT_POSNS, HUNGARIANMODES)
  def_scale :MajorScale, name: "Major", tment: WestTemp,
    note_pos: CHROM_NAT_NOTE_POS, modes: MAJOR_MODES

  def_scale :MelMinorScale, name: "Melodic Minor", tment: WestTemp,
    note_pos: MEL_MIN_NOTE_POS, modes: MEL_MINOR_MODES

  def_scale :HarmMinorScale, name: "Harmonic Minor", tment: WestTemp,
    note_pos: HARM_MIN_NOTE_POS, modes: HARM_MINOR_MODES

  def_scale :HarmMajorScale, name: "Harmonic Major", tment: WestTemp,
    note_pos: HARM_MAJ_NOTE_POS, modes: HARM_MAJOR_MODES

  def_scale :DiscMinorScale, name: "Discordant Minor", tment: WestTemp,
    note_pos: DISC_MIN_NOTE_POS, modes: DISCORD_MIN_MODES

  def_scale :HungarianScale, name: "Hungarian", tment: WestTemp,
    note_pos: HUNGARIAN_NOTE_POS, modes: HUNGARIAN_MODES

  # Pentatonic scales.
  def_scale :MajorPentaScale, name: "Major Pentatonic", tment: WestTemp,
    note_pos: MAJOR_PENTA_NOTE_POS
  def_scale :MinorPentaScale, name: "Minor Pentatonic", tment: WestTemp,
    note_pos: MINOR_PENTA_NOTE_POS
  def_scale :RyukyuPentaScale, name: "Ryukyu Pentatonic", tment: WestTemp,
    note_pos: RYUKYU_PENTA_NOTE_POS

  # Hexatonic scales.
  def_scale :BluesHexaScale, name: "Blues", tment: WestTemp,
    note_pos: BLUES_HEXA_NOTE_POS

end


module MusicSetTheory
  # This is for decomposing a scale into chords. We use this as a test
  # routine so we know what is required.
  #
  def scale_analysis( scale_name, perm_chord_type )
     # 1. Lookup scale name.
     noteseq_founditem = noteseq.find_by_name(scale_name)

     # 2. Find scale pattern.
     ournoteseq = noteseq_founditem.noteseq

     #
     noteseq_founditem.noteseq.getpattern(noteseq_founditem.indices)

     #for i in range(ournoteseq.nseq_posn.len()):
     for i in 0...ournoteseq.nseq_posn.size
       ournoteslice = noteseq_for_slice(i, perm_chord_type)
       notechord_founditem = noteseq.find_by_chord(ournoteslice)

       if notechord_founditem == None
         print("None")
       else
         print(notechord_founditem.getName())
       end
     end

     return
  end

end


#### endof filename: music_set_theory/scales.rb
