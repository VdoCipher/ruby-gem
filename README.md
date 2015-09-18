# ruby-gem
A ruby gem for using VdoCipher API in a ruby on rails application.

## Getting started

###Install

Add this line to your Gemfile in your rails application

``` ruby
gem 'vdocipher'
```


```ruby
require 'vdocipher'
...

vdo_api = VdoCipher.new(clientSecretKey: "CLIENT_SECRET_KEY");
puts vdo_api.play_code("VIDEO_ID", "style=\"height:400px;width:640px;max-width:100%%;\"");
```

You can add any attributes other than id in the function for video container. The div id is assigned internally and used for loading video elements.

