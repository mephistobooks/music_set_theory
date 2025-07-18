#! /usr/bin/env ruby
#
# filename: examples/mt_temperament.rb
#

require_relative "../lib/music_set_theory"


include MusicSetTheory
# tmp = WestTempNew()
generate_west_chords(WestTemp)

#
puts "Temperament."
seq_dict = WestTemp.seq_dict
nseqtype_dict = seq_dict.nseqtype_maps

pad = " "*2
pad2 = pad*2
nseqtype_dict.each {|k, v|
  puts pad+"dict type (nseqtype): #{NSEQ_TYPE_HASH[k]} (#{k})"

  #
  dict = v
  puts pad2+"name_dict (#{dict.name_dict.keys.size}):"
  dict.name_dict.each_with_index {|(k, v), i|
    puts pad2+pad+"(#{i+1}) #{k}: #{v}"
  }
  puts

  puts pad2+"abbr_dict (#{dict.abbr_dict.keys.size}):"
  dict.abbr_dict.each_with_index {|(k, v), i|
    puts pad2+pad+"(#{i+1}) #{k}: #{v}"
  }
  puts

  puts pad2+"seqpos_dict (#{dict.seqpos_dict.keys.size}):"
  dict.seqpos_dict.each_with_index {|(k, v), i|
    puts pad2+pad+"(#{i+1}) #{k}: #{v}"
  }

  puts '-'*40
}


#### endof filename: examples/mt_temperament.rb
