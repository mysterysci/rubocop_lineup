# RubocopLineup

[![Build Status](https://travis-ci.com/mysterysci/rubocop_lineup.svg?branch=master)](https://travis-ci.com/mysterysci/rubocop_lineup)

![Image of Old-Timey Police Lineup](https://upload.wikimedia.org/wikipedia/commons/0/04/Oppstilling-2.jpg)

If yer trying to bring in a new sheriff to the wild, wild west of your legacy codebase,
there's gonna be some outlaws that are just too ornery to contend with. Better to just 
leave those scoundrels be that aren't in your crosshairs and let yer deputies focus on 
what's at hand. 

This gem presumes yer a-usin' git for yer revisionin' purposes. For now, it also figgers
yer always branchin' from master, which, I know, I know, that ain't always how ever'body
out here on the frontier likes to operate, but hey, we're just gettin' started here.

Also, you should know goin' in that we're duck punchin' into a sweet spot of the Rubocop
underbelly, and well, we just may get to fightin' in the future if them Rubocop folk
get some fancy refactorin' ideas.

Not to mention that some o' yer tougher deputies may get sidelined if they need more than
a changed line to do thar job ... we'll just have to see about all that down the road.  

I'm not sure how we fell into a old western theme here with a modern robot-type gem, but
sometimes ... well, sometimes, the bear eats you.    

## Installation

Add this to yer Gemfile:

```ruby
gem 'rubocop_lineup'
```

And then bundle that up:

    $ bundle

Or just put it in with all yer other gems if so inclined:

    $ gem install rubocop_lineup

## Usage

To use it regular-like, add this to the 
[require section](https://github.com/bbatsov/rubocop/blob/master/manual/extensions.md#loading-extensions) 
of .rubocop.yml:

```yaml 
   require:
   - rubocop_lineup
```

If you only need to use it ever' now-n-again, inform yer rubocop with the 
`-r rubocop_lineup` option.

## Contributing

We'd appreciate hearin' some of yer good ideas about our lil project here, and maybe
even if'in you have a problemo or two with it, you might could get some help here 
with that. Mosey over to the project at https://github.com/mysterysci/rubocop_lineup
and have a shot or two with us.

## License

This gem is one o' them open source deals, and our danged lawyers told us we should 
refer you to this here pronouncement: [MIT License](https://opensource.org/licenses/MIT).
