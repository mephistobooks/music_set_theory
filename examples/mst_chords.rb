#! /usr/bin/env ruby
#
#

require_relative "../lib/music_set_theory"


include MusicSetTheory
tmp = WestTempNew()
generate_west_chords(tmp).each_with_index{|e, i|
  puts "(#{i+1}) #{e}:#{e.class}"
  puts "  name:     #{e.name}"
  puts "  type:     #{e.type}"
  puts "  tment:    #{e.tment}"
  puts "  notes:    #{e.notes} (unit: number of semitones)"
  puts "            #{e.notes_deg} (unit: degree, base 0)"

  abbr = "abbr:     #{e.abbr}"
  abbr += "; #{e.abbr_others}" if e.abbr_others.size > 0
  puts "  #{abbr}"
  puts "  syns:     #{e.syns}"
}


#### endof filename: examples/mt_chords.rb
