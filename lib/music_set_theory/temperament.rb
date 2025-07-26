# frozen_string_literal: true
#
# filename: music_set_theory/temperament.rb
#


#-*- coding: UTF-8 -*-
# temperament.py: Representing musical temperaments (and storing sequences
# associated with them).
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

# Too many ideas, so let's work on the fundamentals.
# A musical temperament consists of the following things - keys, and their 
# positions within it. For example, we will start with the 12 chromatic
# scale. We only need to specify the seven natural keys, and their position
# within it. Doing anymore is overkill. For example, this code does not concern
# itself with the frequencies of notes in Hz.


# import re;
# import unittest;
# from .musutility import rotate, multislice, repseq;
require_relative "./musutility"


# Structure.
#
#
module MusicSetTheory

  #
  #
  #
  module Temperament
    #
    extend  MusUtility
    include MusUtility

    # The seq_dict class acts as a dictionary for noteseq instances. It
    # allows users and programmers to look up noteseqs by name, by
    # abbreviation, and by the sequence of integers representing the
    # positions in the sequence. Each seq_dict should be assigned to one
    # dictionary.
    #
    #! seq_dict is the SeqDict class.
    class SeqDict

      # The nseqtype_ins_dict class represents a subdictionary of noteseq
      # instances sharing the same nseq_type. It is useful to split up
      # noteseqs by nseq_type, lest property lookup return the "wrong"
      # object. For example, a major 13 chord has the same pattern of 
      # integral positions as the major scale; i.e., [0, 2, 4, 5, 7, 9, 
      # 11]. To look up the correct object of the two by pattern, the
      # nseq_type must be specified.
      #
      #! nseqtype_ins_dict is the NseqtypeInsDict class.
      class NseqtypeInsDict; end

    end

    # A musical temperament is used to define the possible keys in music, 
    # and also the positions of keys relevant to each other. Our primary
    # example is the western or chromatic temperament, with 12 possible keys.
    # A temperament also defines which of the keys can be represented as
    # naturals (like "C", "D" and "E"), and which need to be represented with
    # accidentals (like "C#" and "Db".
    #
    # Doing anything more at the moment is overkill. For example, we are not
    # intereted in the possible frequencies for notes of a given key.
    class Temperament; end

  end


end


#
#
#
module MusicSetTheory
  module Temperament

    # Unicode string constants for music notation.
    # NOTE. DO NOT USE SINGLE QUOTES.
    M_SHARP   = "\u266f"
    M_NATURAL = "\u266e"
    M_FLAT    = "\u266d"

    # Since this may not display on browsers, there are non-Unicode equivalents.
    #MNU_SHARP   = "#"
    MNU_SHARP   = "#"
    RE_SHARP    = "\\#{MNU_SHARP}"
    MNU_FLAT    = "b"
    MNU_NATURAL = "n"

    # This constant is used for parsing note names into keys.
    #
    # https://docs.ruby-lang.org/ja/latest/doc/spec=2fregexp.html#capture
    # https://docs.ruby-lang.org/ja/latest/doc/spec=2fregexp.html#option
    #
    # ok.
    #RE_NOTEPARSE = /(?<basenotename>    # named capture.
    #                 [A-Z]
    #                 (b|n|\#|           # WARN: hashtag MUST BE ESCAPED
    #                                    # with backslash in Free format mode.
    #                 #{M_FLAT}|#{M_NATURAL}|#{M_SHARP})*
    #                )/x  # free format mode.
    #
    # (#{MNU_FLAT}|#{MNU_NATURAL}|\#|
    #ng. (#{MNU_FLAT}|#{MNU_NATURAL}|#{MNU_SHARP}|  #ng.
    RE_NOTEPARSE = /(?<basenotename>    # named capture.
                     [A-Z]
                     (#{MNU_FLAT}|#{MNU_NATURAL}|#{RE_SHARP}|
                      #{M_FLAT}  |#{M_NATURAL}  |#{M_SHARP})*
                    )/x  # free format mode.

    # Constants used for the nseq_type arguments in noteseqs. See scales.py for
    # more information.
    NSEQ_SCALE = 0  # Used for specifying scales.
    NSEQ_CHORD = 1  # Used for specifying chords.
    NSEQ_TYPE_HASH = {
      NSEQ_SCALE => 'SCALE',
      NSEQ_CHORD => 'CHORD',
    }
    deep_freeze(NSEQ_TYPE_HASH)

  end
end


#
#
#
module MusicSetTheory
  module Temperament


  # Turns all Unicode musical characters in str_note to their ASCII 
  # equivalent, and returns the result.
  #
  # Note: the function is intended for viewing musical scales through
  # deficient browsers like IE 6 and 7. Characters may appear as blocks
  # in these environments.
  def un_unicode_accdtls(str_note)
    ret = str_note.gsub(/#{M_FLAT}/, MNU_FLAT).
            gsub(/#{M_SHARP}/, MNU_SHARP).
            gsub(/#{M_NATURAL}/, MNU_NATURAL)
    ret
  end


  end
end


#
#
#
# The following class seq_dict is used as a multiple key map to noteseq 
# instances, which are defined in scales.poy. However, seq_dict instances are
# stored with temperament objects, which is why they are stored here.
module MusicSetTheory
  module Temperament

    # The nseqtype_ins_dict class represents a subdictionary of noteseq
    # instances sharing the same nseq_type. It is useful to split up
    # noteseqs by nseq_type, lest property lookup return the "wrong"
    # object. For example, a major 13 chord has the same pattern of 
    # integral positions as the major scale; i.e., [0, 2, 4, 5, 7, 9, 
    # 11]. To look up the correct object of the two by pattern, the
    # nseq_type must be specified.
    class SeqDict::NseqtypeInsDict
      attr_accessor :nseq_type
      attr_accessor :name_dict, :abbrv_dict, :seqpos_dict
      def initialize( nseq_type )
        # The constructed for nseqtype_ins_dict. This sets up seperate
        # dictionaries for names, abbreviations and integral position
        # dictionaries.
        self.nseq_type    = nseq_type
        self.name_dict    = {}
        self.abbrv_dict   = {}
        self.seqpos_dict  = {}
      end

      {
        nseq_type:    [:type],
        abbrv_dict:   [:abbr_dict],
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

    # The seq_dict class acts as a dictionary for noteseq instances. It
    # allows users and programmers to look up noteseqs by name, by
    # abbreviation, and by the sequence of integers representing the
    # positions in the sequence. Each seq_dict should be assigned to one
    # dictionary.
    class SeqDict
      attr_accessor :nseq_temp
      attr_accessor :nseqtype_maps

      #  The constructor for seq_dict.
      # ==== Args
      # nseq_types:: a list of possible nseq_type values for lookups.
      # nseq_temp:: the associated temperament object.
      #
      def initialize( nseq_types, nseq_temp )
        self.nseq_temp     = nseq_temp;
        self.nseqtype_maps = {};
        for i in nseq_types
          self.nseqtype_maps[i] = NseqtypeInsDict.new(i);
        end
      end
    end


  end
end


#
#
#
module MusicSetTheory
  module Temperament

    class SeqDict

      # This adds an element to seq_dict.
      # ==== Args
      # elem:: the element to add to seq_dict instance.
      # nseq_type:: the type of the elemenet (such as scale or chord).
      # name_s:: a string, or a sequence of strings. This provides names
      #   as keys that map onto elem.
      # abbrv_s:: a string, or a sequence of strings. This provides 
      #   abbreviations as keys that map onto elem.
      # seqpos:: a sequence. A tuple form will be used as a key that
      #   maps onto elem.
      # ==== Desc
      # If nseq_type is not associated with any of the sub-dictionaries in
      # seq_dict, then this function exits.
      def add_elem( elem, nseq_type, name_s, abbrv_s, seqpos )

        #
        if !(self.nseqtype_maps.include? nseq_type)
          return false
        end

        #
        sub_dictionary = self.nseqtype_maps[nseq_type]

        #
        ourmod = self.nseq_temp.no_keys
        ourtuple = seqpos.map{|i| i % ourmod }.sort.freeze
        sub_dictionary.seqpos_dict[ourtuple] = elem

        #
        if name_s.is_a? String
          sub_dictionary.name_dict[name_s] = elem
        else
          for s in name_s
            sub_dictionary.name_dict[s] = elem
          end
        end

        # if isinstance(abbrv_s, str)
        if abbrv_s.is_a? String
          sub_dictionary.abbrv_dict[abbrv_s] = elem
        else
          for s in abbrv_s
            sub_dictionary.abbrv_dict[s] = elem
          end
        end

        true
      end

      # Checks if there is a subdictionary associated with nseq_type.
      def check_nseqby_subdict( nseq_type )
        #return nseq_type in self.nseqtype_maps
        self.nseqtype_maps.key?(nseq_type)
      end

      # Checks if there is a noteseq with a given name.
      def check_nseqby_name( nseq_type, name )
        # return name in self.nseqtype_maps[nseq_type].name_dict;
        self.nseqtype_maps[nseq_type].name_dict.key?(name)
      end

      # Checks if there is a noteseq with a given abbreviation.
      def check_nseqby_abbrv( nseq_type, abbrv )
        # return abbrv in self.nseqtype_maps[nseq_type].abbrv_dict
        self.nseqtype_maps[nseq_type].abbrv_dict.key?(abbrv)
      end

      # Checks if there is a noteseq with a given sequence position.
      def check_nseqby_seqpos( nseq_type, seqpos )
        # sortedseqpos = tuple(sorted(seqpos))
        # return sortedseqpos in self.nseqtype_maps[nseq_type].seqpos_dict
        sortedseqpos = seqpos.sort.freeze
        self.nseqtype_maps[nseq_type].seqpos_dict.key?(sortedseqpos)
      end


      ### getters.

      # Looks up a noteseq by name.
      def get_nseqby_name( name, nseq_type )
        # return self.nseqtype_maps[nseq_type].name_dict[name]
        self.nseqtype_maps[nseq_type].name_dict[name]
      end

      # Looks up a noteseq by abbreviation.
      def get_nseqby_abbrv( abbrv, nseq_type )
        # return self.nseqtype_maps[nseq_type].abbrv_dict[abbrv]
        self.nseqtype_maps[nseq_type].abbrv_dict[abbrv]
      end

      # Looks up a noteseq by sequence position.
      def get_nseqby_seqpos( seqpos, nseq_type )
        # sortedseqpos = tuple(sorted(seqpos))
        # return self.nseqtype_maps[nseq_type].seqpos_dict[sortedseqpos]
        sortedseqpos = seqpos.sort.freeze
        self.nseqtype_maps[nseq_type].seqpos_dict[sortedseqpos]
      end

    end

  end
end


#
#
#
# A musical temperament is used to define the possible keys in music,
# and also the positions of keys relevant to each other. Our primary
# example is the western or chromatic temperament, with 12 possible keys.
# A temperament also defines which of the keys can be represented as
# naturals (like "C", "D" and "E"), and which need to be represented with
# accidentals (like "C#" and "Db".
# 
# Doing anything more at the moment is overkill. For example, we are not
# intereted in the possible frequencies for notes of a given key.
module MusicSetTheory
  module Temperament

    class Temperament

      #
      attr_accessor :no_keys, :nat_keys, :nat_key_posn
      attr_accessor :no_nat_keys, :nat_key_pos_lookup
      attr_accessor :pos_lookup_nat_key, :nat_key_lookup_order
      attr_accessor :parsenote
      attr_accessor :seq_maps

      # Initialiser.
      # ==== Args
      # no_keys:: the number of keys in the temperament.
      #   !number of semitones in one octave. ex. 12.
      # nat_keys:: an array consisting of the names of the natural
      #   (unsharped or unflattened) keys in the temperament.
      #   ex.
      #     ["C", "D", "E", "F", "G", "A", "B"]
      #
      # nat_key_posn:: the position of the natural keys in the temperament.
      #   These should correspond to the elements in nat_keys.
      #   Positions are calculated base zero.
      #   ex.
      #     [  0,   2,   4,   5,   7,   9,  11]
      #
      # def initialize( no_keys, nat_keys, nat_key_posn )
      def initialize( no_keys       = CHROM_SIZE,
                      nat_keys      = CHROM_NAT_NOTES,
                      nat_key_posn  = CHROM_NAT_NOTE_POS )
        #
        self.no_keys      = no_keys
        self.nat_keys     = nat_keys
        self.nat_key_posn = nat_key_posn

        # Extra variable: no_nat_keys: number of natural keys.
        #self.no_nat_keys = min(len(nat_keys), len(nat_key_posn))
        self.no_nat_keys = [nat_keys.size, nat_key_posn.size].min

        # Extra variable: nat_key_pos_lookup:
        # key -> position (e.g. A -> 9, C->0).
        self.nat_key_pos_lookup = {}

        # Extra variable: post_lookup_nat_key: position
        #   -> key/None (e.g., 9->A, 0->C).
        self.pos_lookup_nat_key = {}

        # Extra variable: nat_key_lookup_order: looks up order of
        # nat_keys (e.g, C->0, D->1... B->6). Reverse translation
        # available by self.nat_keys[order].
        self.nat_key_lookup_order = {}

        #
        for i in 0...self.no_nat_keys
          self.nat_key_pos_lookup[nat_keys[i]]      = nat_key_posn[i]
          self.pos_lookup_nat_key[nat_key_posn[i]]  = nat_keys[i]
          self.nat_key_lookup_order[nat_keys[i]]    = i
        end

        # self.parsenote = re.compile(RE_NOTEPARSE);
        self.parsenote = Regexp.compile(RE_NOTEPARSE)

        #  Useful for dictionary lookup later.
        #self.seq_maps = seq_dict([NSEQ_SCALE, NSEQ_CHORD], self);
        self.seq_maps = SeqDict.new([NSEQ_SCALE, NSEQ_CHORD], self)

      end

      # Alias methods of getters+setters.
      # {
      #   original_base_name: [ name of aliases ],
      #   original_base_name: [ name of aliases ],
      #   :
      #   :
      # }
      #
      {
        no_keys:      [ :num_semitones, :num_keys, ],
        nat_keys:     [ :natural_key_names, ],
        nat_key_posn: [ :natural_key_positions, ],
        no_nat_keys:  [ :num_natural_keys, ],
        nat_key_pos_lookup: [
          :natural_key_position_lookup, :natural_key_position_dict, ],
        pos_lookup_nat_key: [
          :position_natural_key_lookup, :position_natural_key_dict, ],

        seq_maps: [:seq_dict],
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
end


#
#
#
module MusicSetTheory
  module Temperament

    class Temperament

      # Parses the name of a key into the tuple (natural key name,
      # sharp_or_flat count).
      # ==== Args
      # key:: note.
      #
      # ==== Returns
      # an array: [ <root note>, <adj number> ].
      #   For example "C#" is parsed into ["C", 1], "Db" is parsed
      #   into ["D", -1], and "E" is parsed into ["E", 0].
      #   As the reader may gather, negative numbers are used for 
      #   flattened notes.
      #
      def note_parse( key, debug_f: false )
        noteMatch = self.parsenote.match(key)
        $stderr.puts "{#{__method__}} key (#{key.length}): #{key}"  if debug_f
        $stderr.puts "  =>#{noteMatch[:basenotename].chars}"        if debug_f
        return nil if !(noteMatch)

        #
        # $stderr.puts "note_match: #{noteMatch}:#{noteMatch.class}"
        # noteGroup = noteMatch.group('basenotename')
        noteGroup = noteMatch[:basenotename].chars
        baseNote  = noteGroup[0];
        $stderr.puts "key: #{key}::" +
          " note_group: #{noteGroup.inspect}:#{noteGroup.class}," +
          " chars(#{noteGroup.size}): #{noteGroup};" +
          " base_note: #{baseNote}"  if debug_f

        #
        flatSharpAdj = 0
        for chr in noteGroup[1..]
          $stderr.puts "{#{__method__}} adj: #{chr}"  if debug_f
          if /#{chr}/ =~ (M_FLAT + MNU_FLAT)
            flatSharpAdj += -1
          end
          if /#{chr}/ =~ (M_SHARP + MNU_SHARP)
            flatSharpAdj += +1
          end
        end

        [ baseNote, flatSharpAdj,]
      end

      # Returns the position of the key in the temperament.
      # ==== Args
      # key:: key note. ex. "C", "D#", "Cb"
      #
      # ==== Returns
      # position of the key in the unit of halftone. ex. key: "C"  =>0,
      # key: "D#" =>3, key: "Cb" =>-1
      #
      # ==== See Also
      # - `#get_key_of_pos()`
      #
      def get_pos_of_key( key, debug_f: false )
        key_parsed = self.note_parse(key)
        $stderr.puts "key_parsed: #{key_parsed}"  if debug_f
        $stderr.puts "nat_key_pos_lookup: #{self.nat_key_pos_lookup}" if \
          debug_f

        ret = self.nat_key_pos_lookup[key_parsed[0]] + key_parsed[1]
        ret
      end
      alias pos_of_key  get_pos_of_key
      alias position_of get_pos_of_key
      alias pos_of      get_pos_of_key

      # Given a position in the temperament, this function attempts to
      # return the "best" key name corresponding to it. This is not a 
      # straight-forward reverse of get_pos_of_key, as there may be two
      # different keynames for the same position, with one preferred. For
      # example, "C# and "Db" are the same key, but "C# is preferred in an
      # A major scale. Fortunately, arguments are provided to indicate the
      # programmer's preference.
      # ==== Args
      # pos:: the position inside the temperament.
      # desired_nat_note:: the preferred natural key to start the key name.
      #   For example "C" makes the function return "C#" instead of "Db".
      #   If nil, then the preference depends on...
      # sharp_not_flat:: if true, returns the sharpened accidental form 
      # (e.g., "C#"); if false, returns the flattened accidental form
      # (i.e., "Db").
      # ==== Returns
      #
      def get_key_of_pos( pos, desired_nat_note = nil, sharp_not_flat = nil )

        # accdtls: number of sharps or flats to add to the output string.

        if desired_nat_note
          accdtls = pos - self.nat_key_pos_lookup[desired_nat_note]
          accdtls = (accdtls % self.no_keys)

          if accdtls > (self.no_keys / 2)
            accdtls = accdtls - self.no_keys
          end

          if accdtls > 0
            return desired_nat_note + (M_SHARP * accdtls)
          elsif accdtls < 0
            return desired_nat_note + (M_FLAT * (-1 * accdtls))
          else
            return desired_nat_note
          end
        else
          accdtls = 0
          # if (pos % self.no_keys) in self.pos_lookup_nat_key
          if self.pos_lookup_nat_key.key?( pos % self.no_keys )
            return self.pos_lookup_nat_key[pos % self.no_keys]

          elsif sharp_not_flat
            while accdtls < self.no_keys
              accdtls = accdtls - 1
              #if ((pos + accdtls) % self.no_keys) in self.pos_lookup_nat_key
              if self.pos_lookup_nat_key.key?((pos + accdtls) % self.no_keys)
                return self.pos_lookup_nat_key[
                  (pos + accdtls) % self.no_keys] + (M_SHARP * (-1 * accdtls))
              end
            end

          else
            while accdtls < self.no_keys
              accdtls = accdtls + 1
              #if ((pos + accdtls) % self.no_keys) in self.pos_lookup_nat_key:
              if self.pos_lookup_nat_key.key?((pos + accdtls) % self.no_keys)
                return self.pos_lookup_nat_key[
                  (pos + accdtls) % self.no_keys] + (M_FLAT * accdtls)
              end
            end

          end
        end

        return nil
      end
      alias key_of_pos get_key_of_pos
      alias key_of     get_key_of_pos


      # This function takes a key and a sequence of positions relative to
      # it. It returns a sequence of notes.
      # ==== Args
      # key:: the starting key; examples are "C", "C#" and "Db".
      # pos_seq:: a list of positions relative to it in the temperament
      #   base 0). For example, in the Western/Chromatic temperament, a
      #   key of "C" and a sequence of [0, 1] returns ["C", "C#].
      # nat_pos_seq:: a list of numbers. These are used to calculate the
      #   desired natural notes produced from the corresponding positions
      #   in pos_seq. A number of 0 means to use the same natural note as
      #   in key, a number of 1 means using the next natural note, and so
      #   on. Examples for the Western/Chromatic scale:
      #     get_note_sequence("C", [0, 1], [0, 0]) =>["C", "C#"]
      #     get_note_sequence("C", [0, 1], [0, 1]) =>["C", "Dbb"]
      #     get_note_sequence("C", [0, 1], [0, 6]) =>["C", "B##"]
      # sharp_not_flat:: if nat_pos_seq is None, indicates whether notes 
      #   with accidentals are preferred to have sharps (True) or flats
      #   (False)
      # ==== Returns
      #
      # ==== See Also
      # - `#get_keyseq_notes()`
      #
      def get_note_sequence( key, pos_seq,
                             nat_pos_seq = nil, sharp_not_flat = nil )
        ret = nil
        base_key_pos   = self.get_pos_of_key(key)
        #result_pos_seq = [((base_key_pos + i) % self.no_keys) for i in pos_seq]
        result_pos_seq = pos_seq.map{|i| (base_key_pos + i) % self.no_keys }

        if nat_pos_seq
          result_seq = []
          desired_nat_key = self.note_parse(key)[0]
          desired_nat_key_posn = self.nat_keys.index(desired_nat_key)

          #for i in range(min(len(nat_pos_seq), len(result_pos_seq))):
          for i in 0...([nat_pos_seq.size, result_pos_seq.size].min)
            des_nat_note = self.nat_keys[
              (desired_nat_key_posn + nat_pos_seq[i]) % self.no_nat_keys]
            des_key = self.get_key_of_pos(result_pos_seq[i], des_nat_note)
                   result_seq.append(des_key)
          end
          ret = result_seq

        else
          # return [self.get_key_of_pos(i, None, sharp_not_flat) for i in
          #   result_pos_seq];
          ret = result_pos_seq.map{|i|
                  self.get_key_of_pos(i, nil, sharp_not_flat) }
        end

        ret
      end


      # The reverse of get_note_sequence().
      # ==== Args
      # note_seq:: a sequence of notes (note_seq)
      # ==== Returns
      # [base key, position sequence]
      # ==== Examples
      # ["C", "D"]        =>["C", [0, 2]]
      # ["D", "C#", "E"]  =>["D", [0, 11, 2]]
      #
      # this is returned by the function.
      # ==== See Also
      # - `#get_note_sequence()`
      #
      def get_keyseq_notes( note_seq )
        base_key = note_seq[0]
        base_pos = self.get_pos_of_key(base_key)
        pos_seq  = note_seq.map{|i|
                     (self.get_pos_of_key(i) - base_pos) % self.no_keys }

        [base_key, pos_seq]
      end

    end

  end
end


#
#
#
module MusicSetTheory
  module Temperament

    class Temperament


      ### The next few functions are rip-offs of SeqDict functions.
      #
      #! actually these are the utility methods for SeqDict instance.
      #


      # This adds an element to the dictionary inside the temperament.
      # ==== Args
      # elem:: the element to add  to the dictionary .
      # nseq_type:: the type of the elemenet (such as scale or chord).
      # name_s:: a string, or a sequence of strings. This provides names
      #   as keys that map onto elem.
      # abbrv_s:: a string, or a sequence of strings. This provides 
      #   abbreviations as keys that map onto elem.
      # seqpos:: a sequence. A tuple form will be used as a key that
      #   maps onto elem.
      #
      # If nseq_type is not associated with any of the sub-dictionaries in
      # the dictionary in the temperament, then this function exits.
      #
      def add_elem( elem, nseq_type, name_s, abbrv_s, seqpos )
        self.seq_dict.add_elem(elem, nseq_type, name_s, abbrv_s, seqpos)
      end


      # Checks if there is a subdictionary associated with nseq_type.
      def check_nseqby_subdict( nseq_type )
        self.seq_dict.check_nseqby_subdict(nseq_type)
      end

      # Checks if there is a noteseq with a given name.
      def check_nseqby_name( nseq_type, name )
        self.seq_dict.check_nseqby_name(nseq_type, name)
      end

      # Checks if there is a noteseq with a given abbreviation.
      def check_nseqby_abbrv( nseq_type, abbrv )
        self.seq_dict.check_nseqby_abbrv(nseq_type, abbrv)
      end

      # Checks if there is a noteseq with a given sequence position.
      def check_nseqby_seqpos( nseq_type, seqpos )
        self.seq_dict.check_nseqby_seqpos(nseq_type, seqpos)
      end

      # Looks up a noteseq (or anything else) by name.
      def get_nseqby_name( name, nseq_type )
         if self.seq_dict.check_nseqby_name(nseq_type, name)
           self.seq_dict.get_nseqby_name(name, nseq_type)
         else
           nil
         end
      end

      # Looks up a noteseq (or anything else) by abbreviation.
      def get_nseqby_abbrv( abbrv, nseq_type )
           if self.seq_maps.check_nseqby_abbrv(nseq_type, abbrv)
             self.seq_maps.get_nseqby_abbrv(abbrv, nseq_type)
           else
             nil
           end
      end

      # Looks up a noteseq (or anything else) by sequence position.
      def get_nseqby_seqpos( seqpos, nseq_type )
        if self.seq_maps.check_nseqby_seqpos(nseq_type, seqpos)
          self.seq_maps.get_nseqby_seqpos(seqpos, nseq_type)
        else
          nil
        end
      end

    end

  end
end


# We immediately use this class to define a Western or Chromatic temperament
# object. Apart from useful for understanding the class, the object is used in
# testing.
module MusicSetTheory
  module Temperament

    #
    # CHROM_SIZE:: number of semitones.
    # CHROM_NAT_NOTE_POS:: position in number of semitones.
    #   ex. D = 2 (i.e., C + #*2), E = 4 (C + #*4), etc.
    # CHROM_NAT_NOTES:: natural notes.
    #
    CHROM_SIZE          = 12
    CHROM_NAT_NOTES     = ["C", "D", "E", "F", "G", "A", "B"]
    CHROM_NAT_NOTE_POS  = [  0,   2,   4,   5,   7,   9,  11]
    def self.WestTempNew
      Temperament.new(CHROM_SIZE, CHROM_NAT_NOTES, CHROM_NAT_NOTE_POS)
    end
    def WestTempNew
      MusicSetTheory::Temperament.WestTempNew()
    end

    #WestTemp = deep_freeze(WestTempNew()) # the last failed in chords_test(1).
    #WestTemp = WestTempNew()  # the last failed in chords_test(1).
    #ng. WestTemp.deep_freeze

    ### freeze for debug.
    # WestTemp = MusicSetTheory.deep_freeze(WestTempNew())
    WestTemp  = WestTempNew()  # ok. (dependancied removed in test cases).
    WestTment = WestTemp  # alias.

  end
end



#### endof filename: music_set_theory/temperament.rb
