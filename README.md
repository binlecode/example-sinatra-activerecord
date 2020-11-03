# example project of Sinatra with ActiveRecord


## ruby, gemset and gems

Assume rvm and gemset:

`ruby-2.5.7@test-sinatra`

Generate ruby and gemset setting files:
```bash
rvm --ruby-version use ruby-2.5.7@test-sinatra
```

Install gems:

```bash
bundle install
```

## database setup

Check `app.rb` for database setup.

In the Terminal test that it works
```bash
bundle exec rake -T
```

Create a migration for creating a users table
```bash
bundle exec rake db:create_migration NAME=create_users_table
```

Then add db change to the created migration file.

Note the `[6.0]` Rails version number is specified for ActiveRecord.
Otherwise migration will return error: 
"Directly inheriting from ActiveRecord::Migration is not supported. Please specify the Rails release the migration was written for..."

```ruby
class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
```

Then apply migration:
```bash
bundle exec rake db:migrate
```






