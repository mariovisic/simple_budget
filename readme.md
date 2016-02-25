# Simple Budget

Super simple budgeting tool that works the way I like. I have tried many
different budgeting apps and none of them work exactly the way i'd like.
Everyone is differnt.

UI is designed to be accessible from a phone only and there are purposely no
settings as the app works just for me.


## TODO:

- [ ] Setup very basic password protection
- [ ] Allow transactions to be modified
- [ ] Import existing data
- [ ] Deploy to heroku
- [ ] Setup routine to run before controller actions to update weekly deposits if out of date


## Password protecting the application

The app has a VERY basic authorization system which entirely allows your blocks
you from the app with a provided password (no username)

To active simply set the PASSWORD_HASH environment variable to the bcrypt hash
of your password, you can generate one with:

```ruby
require 'bcrypt'
BCrypt::Password.create("my password")
```
