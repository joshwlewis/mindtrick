# Mindtrick

Mindtrick is a Ruby library for search suggestion completion.

Mindtrick uses Redis's sorted sets to store and track popularity of completed
terms relative to incomplete search terms. As more users search, the more
helpful the suggestions become.

## Usage

Require Mindtrick and setup a new instance:
```ruby
require 'mindtrick'
mt = Mindtrick.new
```

Each time a user submits a search, add the query:
```ruby
mt.add('these are not the droids you are looking for')
```

When the user inputs a few letters, get a list of suggestions:
```ruby
mt.suggest('T')
# => ['these are not the droids you are looking for']
```

Terms are scored, so that the most frequently searched terms are suggested:
```ruby
['foo', 'foobar', 'foobar', 'foosball', 'foosball', 'foosball'].each do |term|
  mt.add(term)
end

mt.suggest('foo', 2)
# => ['foosball', 'foobar']
```

## Options

### redis

You can tell Mindtrick what redis instance you want to connect to. By default,
Mindtrick assumes Redis is on localhost with default credentials.

```ruby
Mindtrick.new(redis: Redis.new(url: "redis://..."))
```

### prefix

By default, all sets created by Mindtrick are prefixed with 'mndtrk'.
You can change this if you don't like it, or if you have multiple suggestion
contexts:

```ruby
Mindtrick.new(prefix: 'searchbox1')
```

### max_terms

To prevent balooning of your Redis instance, we prune unpopular terms so that
there are only 250 terms per prefix. This number can be tweaked to your liking.

```ruby
Mindtrick.new(max_terms: 100)
```

### max_length

Again, to prevent balooning of your Redis instance, Mindtrick doesn't keep
suggestions over 15 characters in length. You can tweak this as needed:

```ruby
Mindtrick.new(max_length: 20)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mindtrick'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install mindtrick
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mindtrick/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
