#
# frozen_string_literal: true
#
# filename: music_set_theory/musutility.rb
#


# Defines utility functions not properly part of other modules.
#
#

#-*- coding: UTF-8 -*-
# musutility.py: Defines utility functions not properly part of other modules.
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


# import sys;
# import codecs;
# import unittest;

#
#
#
module MusicSetTheory

  module MusUtility; end

  extend  MusUtility
  include MusUtility
end


#
#
#
module MusicSetTheory
  module MusUtility


    # One of the common problems with python 2.x is that its print function does 
    # not handle Unicode strings with characters values greater than 127. For this
    # reason, we provide our own. It is used only for debugging. 
    
    # def printunicode(value, encoding = "utf-8"):
    #     """ Prints an unescaped unicode string to the system console. """
    #     uval = str(value);
    #     sys.stdout.write(codecs.encode(uval + '\n', encoding));
    

    #
    # Make sequences representable as strings.
    #
    # Writes a sequence as a comma delimited string.
    def seqtostr( value )
      ary = value
      ary = ary.to_a unless ary.is_a? Array
      ary.join(", ")
    end
    #
    # def seqtostr(value):
    #     """ Writes a sequence as a comma delimited string. """
    #     output = "";
    #     if not value:
    #         return output;
    #     for i in value:
    #         output += str(i) + ", ";
    #         
    # Trim the last two characters.
    # 
    #     return output[:-2];


    # The next few functions are for rotating sequences and choosing "multiple
    # element slices" See multislice for more information.
    #

    #
    # Original comments:
    # Rotates a seq to the left by offset places; the elements shifted off
    # are inserted back at the end. By setting offset to the negative number -N,
    # this function rotates the sequence N places.
    #
    # Note: this algorithm is a modification of one originally provided by
    # Thorsten Kampe; this version handles zero sequences and right shifts. See:
    # http://bytes.com/topic/python/answers/36070-rotating-lists
    def rotate( seq, offset )
      seq.rotate(offset)
    end
    #     if (len(seq) == 0) or (offset == 0):
    #         return seq;
    #     else:
    #         offsetmod = offset % len(seq);
    #         return seq[offsetmod:] + seq[:offsetmod];


    #
    # Original comments:
    # Returns the result of adding scalar (a number) to all elements in seq.
    # If mod is not 0, then all addition occurs modulo mod.
    #
    # Note: this function is an "analogue" of scalar multiplication - an
    # operation where every element in a sequence is multiplied by a scalar.
    # We can also use this function to perform "scalar subtraction" - the
    # subtraction of a scalar from all elements in a sequence.
    # """
    def scalar_addition( seq, scalar, mod = 0 )
      seq.map{|index|
        if 0 == mod
          index + scalar
        else
          (index + scalar) % mod
        end
      }
    end


    #
    # Original comments:
    # Returns the result of:
    #   (a) rotating a sequence to a given offset; and then,
    #   (b) scalar subtracting the resulting first element from the rotated
    #       sequence.
    # The result always begins with zero (except when seq is []).
    # If mod is not 0, then all subtraction occurs modulo mod.
    #
    # Note: this function is useful in generating different modes of a scale
    # and different synonyms of a chord.
    #
    def rotate_and_zero( seq, offset, mod = 0, debug_f: false )
      return seq if seq.empty?

      rotated_seq = rotate(seq, offset)
      first_elem  = rotated_seq[0]
      $stderr.puts "{#{__method__}} seq: #{seq}, offset: #{offset}" if debug_f
      $stderr.puts "{#{__method__}} rotated: #{rotated_seq}," +
        " 1st: #{first_elem.inspect}" if debug_f

      return scalar_addition(rotated_seq, 0 - first_elem, mod)
    end


    #
    # The multislice function takes a multiple-element-slice (see below) of
    # a sequence, rotates it if necessary afterward, and returns it. The
    # arguments:
    # ==== Args
    # seq:: a sequence to slice and/or rotate.
    # slice:: another sequence which specifies the elements preserved in
    #   seq. This consists of integers, which indicate the indices of
    #   elements in seq to preserve. If i is in slice, then seq[i] is
    #   preserved; otherwise, it is discarded. (Slicing always happens
    #   before rotation).
    # mod:: if present, then all indices in slice are taken modulo this
    #   number. I.e., seq[j] is preserved if and only if j some k modulo
    #   mod, where k is in slice.
    # offset:: after slicing, this sequence is rotated this number of places.
    #
    # def multislice( seq, slice, mod = 0, offset = 0 )
    def multislice( seq, slice, mod: 0, offset: 0 )
      ret = nil
      if 0 == mod
        ret = slice.map{|index| rotate(seq, offset)[index] }
      else
        ret = slice.map{|index| rotate(seq, offset)[index % mod] }
      end
      ret
    end


    # Generates a unicode string from the items in seq delimited by commas.
    # For example repseq([1, 2, 3]) produces "1, 2, 3". Arguments:
    # seq: a sequence of items.
    # pre_process: a function taking one argument and returning another. The
    # function will execute this on each item in seq before concatenating
    # them together. By default, nothing is done to each argument.
    # 
    SPACECOMMA = ", "
    def repseq( seq, pre_process = lambda{|x| x} )
      if seq.size == 0
        return ""
      end
      #str_out = ''.join([(str(pre_process(item)) + SPACECOMMA)
      #  for item in seq[:-1]]) + str(pre_process(seq[-1]));

      # ret = (seq[0...-1].map{|item| pre_process.(item).to_s }.join(SPACECOMMA)) +
      #       + SPACECOMMA + pre_process.(seq[-1]).to_s
      ret = (seq[0...-1].map{|item| pre_process.(item).to_s } +
             [pre_process.(seq[-1]).to_s]).join(SPACECOMMA)

      ret
    end


    # Returns a sequence of sequences, with each element consisting of an
    # element from otherentries appended to a sequence from seq_of_seq.
    #
    # Note: this is used for building chords.
    #
    def enl_seq( seq_of_seq, otherentries )
      ret = []
      for i in seq_of_seq
         for j in otherentries
             ret.append(i + [j])
         end
      end
      ret
    end


    # This function takes a sequence (of numbers) and "normalizes" it. To
    # be specific, it evaluates all numbers inside seq modulo mod. The
    # result is then sorted, and any duplicates are removed.
    #
    # Note: this function is useful for looking up chords by their patterns.
    #
    def norm_seq( seq, mod )

      #sorted_seq = sorted([x % mod for x in seq])
      sorted_seq = seq.map{|x| x % mod }.sort

  # We remove duplicates. The following code is straight outta the Python FAQ.

      #
      last = sorted_seq[-1]
      # for i in range(len(sorted_seq)-2, -1, -1)
      (sorted_seq.size-2).step(0, -1) do |i|
        if last == sorted_seq[i]
          # del sorted_seq[i]
          sorted_seq.delete_at(i)
        else
          last = sorted_seq[i]
        end
      end

      sorted_seq
    end

  end
end

require 'active_support'
require 'active_support/core_ext/object/deep_dup'
require 'ice_nine'
module MusicSetTheory
  module MusUtility

    def deep_freeze( obj )
      IceNine.deep_freeze(obj)
    end

    def deep_melt( obj )
      case obj
      when Hash
        obj.each_with_object({}) do |(key, value), new_hash|
          new_hash[deep_melt(key)] = deep_melt(value)
        end
      when Array
        obj.map { |element| deep_melt(element) }
      when Object
        # インスタンス変数の解除
        obj.instance_variables.each do |var|
          deep_melt(var)
          value = obj.instance_variable_get(var)
          obj.remove_instance_variable(var)
          obj.instance_variable_set(var, deep_melt(value))
        end
        obj.dup rescue obj # 凍結状態を解除
      else
        obj.dup rescue obj
      end
      obj.dup rescue obj
    end

  end
end


#### endof filename: music_set_theory/musutility.rb
