# MusicTheory

`music_theory.gem` is ruby version of `musictheory` of python package, by Peter Murphy.
> The package has roughly the same philosophy as [Music Set Theory](https://www.jaytomlin.com/music/settheory/help.html) but uses different terminology.

The music theory treats notes and the relationships among them, i.e., temperament, chords, scale, modes, etc.



## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

See the `examples/` directory. The scripts for listing chords and scales are there.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

If you want to test all:

```bash
bundle exec rake test
```

test a specified one:

```bash
TEST=./test/something_test.rb  bundle exec rake test
```

If you want to test a test in a specified file, then:

```bash
TESTOPTS=--name=/pattern-matches-to-the-description/ TEST=./test/something_test.rb  bundle exec rake test
```

## Future Works, etc.

I would like to add some examples, debug more, and refactor the structure and method names...
(Actually, I don't have the knowledge about temperament and modes at (almost) all, though I
can understand chords and scales a little since I had played the guitar.)

The state-dependencies exists in the original test cases on `WestTemp`. So I have already removed them.
All tests, including commented out one (`TestChords`), are passed now.

## Contributing

Bug reports and pull requests are welcome on GitHub at `https://github.com/mephistobooks/music_theory`.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

The original [`musictheory`](https://github.com/peterkmurphy/musictheory) is BSD 3-clauses Licence.

```
Copyright (c) 2009-2020 Peter Murphy <peterkmurphy@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * The names of its contributors may not be used to endorse or promote 
      products derived from this software without specific prior written
      permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

