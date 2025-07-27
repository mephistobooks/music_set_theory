#
# frozen_string_literal: true
#
# filename: music_set_theory/chord_generator.rb
#
# Generating tables of chords associated with scales.


#-*- coding: UTF-8 -*-
# chordgenerator.py: Generating tables of chords associated with scales.
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
#
# This software was originally written by Peter Murphy (2008). It has been
# updated in 2011 to use the assoicated musictheory classes. Updated for 2011.
#
# The goal of this utility is to find all the possible chords (major, minor, 
# 7th) in common diatonic scales (such as Major and Harmonic Minor).  The
# results are tables that can be displayed in an HTML file.


require_relative "./musutility"
require_relative "./temperament"
require_relative "./scales"
require_relative "./chords"

require 'romanumerals'


# import copy, codecs
# from .musutility import seqtostr;
# from .temperament import WestTemp, temperament, WestTemp, seq_dict,\
#     NSEQ_SCALE, NSEQ_CHORD, M_SHARP, M_FLAT;
# from .scales import MajorScale, MelMinorScale, HarmMinorScale,\
#     HarmMajorScale;
# from .chords import CHORDTYPE_DICT;
require_relative "musutility"
require_relative "temperament"
require_relative "scales"
require_relative "chords"


#
#
#
module MusicSetTheory

  class ScaleChords;    end
  class ScaleChordRow;  end
  class ScaleChordCell; end

end


#
#
#
module MusicSetTheory

  # Used to give a full list of chord types.
  CHORDTYPE_ARRAY = [
    "Fifth", "Triad", "Seventh", "Ninth", "Eleventh", "Thirteenth",
    "Added Ninth", "Suspended", "Suspended Seventh", "Sixth", "Sixth/Ninth",
    "Added Eleventh",
  ]

  #
  PRINT_ABBRV = 0
  PRINT_FNAME = 1
  PRINT_BOTH  = 2

end


module MusicSetTheory

  # Roman numerals are used for the table headers.

  # Following routine comes from "Roman Numerals (Python recipe)".
  # Author: Paul Winkler on Sun, 14 Oct 2001. See:
  # http://code.activestate.com/recipes/81611-roman-numerals/

#    """
#    Convert an integer to Roman numerals.
# 
#    Examples:
#    >>> int_to_roman(0)
#    Traceback (most recent call last):
#    ValueError: Argument must be between 1 and 3999
# 
#    >>> int_to_roman(-1)
#    Traceback (most recent call last):
#    ValueError: Argument must be between 1 and 3999
# 
#    >>> int_to_roman(1.5)
#    Traceback (most recent call last):
#    TypeError: expected integer, got <type 'float'>
# 
#    >>> for i in range(1, 21): print int_to_roman(i)
#    ...
#    I
#    II
#    III
#    IV
#    V
#    VI
#    VII
#    VIII
#    IX
#    X
#    XI
#    XII
#    XIII
#    XIV
#    XV
#    XVI
#    XVII
#    XVIII
#    XIX
#    XX
#    >>> print int_to_roman(2000)
#    MM
#    >>> print int_to_roman(1999)
#    MCMXCIX
#    """
  def int_to_roman( input )
    raise ArgumentError, "#{input} must be greater than zero." if input <= 0
    raise TypeError, "Input must be an integer." unless input.is_a? Integer

    input.to_roman
  end

  #
  # Make a sequence of roman numerals from 1 to num.
  def make_roman_numeral_list( num )
    #return([int_to_roman(i) for i in range(1, num + 1)])
    (1...(num + 1)).map{|i| int_to_roman(i) }
  end

end


module MusicSetTheory
  # Represents all the chords associated with a scale. This is
  # used to make a tabular representation.
  #
  class ScaleChords

    attr_accessor :full_name, :key, :full_notes, :table_title, :rows
    def initialize( full_name, key, full_notes, table_title )
      self.full_name    = full_name
      self.key          = key
      self.full_notes   = full_notes
      self.table_title  = table_title
      self.rows         = []
    end

    def to_a
      tmp = []
      tmp << [ self.full_name, self.key, self.full_notes, self.table_title, ]

      #
      self.rows.map{|r|
        # tmp << r.to_a
        # tmp += r.to_a
        tmp << r.to_a
      }

      ret = tmp
      ret
    end

  end

  # Represents different rows (triads, 7ths, 9ths) in tabular
  # representations of scale chords.
  #
  class ScaleChordRow
    attr_accessor :chord_type, :notes
    def initialize( chord_type )
      self.chord_type = chord_type
      self.notes = []
    end

    def to_a
      # ret = "#{self.chord_type}:#{self.notes}"
      tmp = []
      self.notes.each do |nt|
        tmp << [self.chord_type,] + nt.to_a
      end
      ret = tmp
      ret
    end
  end

  # Represents different cells in the table of chords.
  class ScaleChordCell
    attr_accessor :chordname_1, :chordname_2, :notes
    def initialize( chordname_1, chordname_2, notes )
      self.chordname_1 = chordname_1
      self.chordname_2 = chordname_2
      self.notes = notes
    end

    def to_a
      [self.chordname_1, self.chordname_2, self.notes]
    end
  end

end


module MusicSetTheory

  # Used for converting "C" -> 1, "Db"-> 2b, etc.
  #
  #
  def makebaserep( notex, base = 0 )
    notexparsed = WestTemp.note_parse(notex)
    #pos_rep = str(WestTemp.nat_key_lookup_order[notexparsed[0]] + base)
    pos_rep = (WestTemp.nat_key_lookup_order[notexparsed[0]] + base).to_s

    if notexparsed[1] > 0
      ret = pos_rep + (M_SHARP * notexparsed[1])
    elsif notexparsed[1] < 0
      ret = pos_rep + (M_FLAT * (-1 * notexparsed[1]))
    else
      ret = pos_rep
    end

    ret
  end


  # Returns an instance of scale_chords using the following inputs:
  # ==== Args
  # scale_name:: a name of a scale like "Dorian".
  # key:: generally a standard music key like "C".
  # possiblechords:: a sequence of chord types like "Seventh" and "Ninth".
  # west_temp:: Temperament object.
  #
  # ==== Returns
  # ScaleChords object.
  #
  #def populate_scale_chords( scale_name, key, possiblechords )
  def populate_scale_chords( scale_name, key, possiblechords,
                             west_temp = WestTemp )
    our_scale = west_temp.get_nseqby_name(scale_name, NSEQ_SCALE)
    # num_elem = len(our_scale.nseq_posn)
    num_elem = our_scale.nseq_posn.size

    begin
      int_of_key    = key.to_i
      is_key_an_int = true
    rescue ValueError
      is_key_an_int = false
      int_of_key    = nil
    end

    if is_key_an_int
      #our_scale_notes = [makebaserep(x, int_of_key) for x in 
      #our_scale.get_notes_for_key("C")]
      our_scale_notes = our_scale.get_notes_for_key("C").map{|x|
                          makebaserep(x, int_of_key) }
    else
      our_scale_notes = our_scale.get_notes_for_key(key)
    end

    our_chord_data = ScaleChords.new(scale_name, key, our_scale_notes,
                       make_roman_numeral_list(num_elem))

    for i in possiblechords
      ourchordrow = ScaleChordRow.new(i)
      our_chord_data.rows.append(ourchordrow)

      # for j in range(num_elem):
      for j in 0...num_elem
        our_slice = CHORDTYPE_DICT[i]

        if is_key_an_int
          #our_chord_notes = [makebaserep(x, int_of_key) for x in
          #  our_scale.get_notes_for_key("C", j, our_slice)]
          our_chord_notes = our_scale.get_notes_for_key("C", j, our_slice).
                              map{|x| makebaserep(x, int_of_key) }
        else
          our_chord_notes = our_scale.get_notes_for_key(key, j, our_slice)
        end

        #our_posn  = our_scale.get_posn_for_offset(j, our_slice, true)
        our_posn  = our_scale.get_posn_for_offset(j, our_slice, raz: true)
        our_chord = west_temp.get_nseqby_seqpos(our_posn, NSEQ_CHORD)
        if our_chord
          ourchordrow.notes.append(ScaleChordCell.new(our_chord.nseq_name,
            our_chord.nseq_abbrev, our_chord_notes))
        else
          ourchordrow.notes.append(ScaleChordCell.new("", "", our_chord_notes))
        end

      end
    end

    return our_chord_data
  end


  # (**) I dont need this.
  # Generates a table representation of a series of scales,
  # represented by a scale_chords instance.
  #
  def chordgentable( scales )
    startrow  = "<tr>\n"
    endrow    = "</tr>\n"
    thestring = ""


    for scale in scales
      thestring += "<h2>%s</h2>\n" % (scale.key + " " +scale.full_name)
      thestring += ("<table id=\"%s\" class=\"chordtable\">\n" % 
          (scale.key + ""))
      thestring += "<caption>%s</caption>\n" %
        (scale.key + " " + scale.full_name +
          ": " + seqtostr(scale.full_notes))
      thestring += "<thead>\n" + startrow + "<th>Chord Types</th>\n"
      # for q in range(7)
      for q in 0...7
        thestring += "<th>%s</th>\n" % str(int_to_roman(q+1))
      end
      thestring += endrow + "</thead>\n<tbody>\n"

      for i in scale.rows
        thestring += startrow
        thestring += "<td>%s</td>\n" % i.chord_type
        for j in i.notes
          if not j.chordname_1
            thestring += ("<td><p>%s<br />" % (str(j.chordname_1)))
            thestring += ("<i>%s</i><br />" % (str(j.chordname_2)))
          else
            thestring += ("<td><p>%s<br />" %
                          (j.notes[0]+" "+str(j.chordname_1)))
            thestring += ("<i>%s</i><br />" % (j.notes[0]+str(j.chordname_2)))
          end

          thestring += ("<b>%s</b></p></td>" % seqtostr(j.notes))
        end
        thestring += endrow
      end
      thestring += "\n</tbody>\n</table>\n"
    end

    return thestring
  end


end


#### endof filename: music_set_theory/chord_generator.rb
