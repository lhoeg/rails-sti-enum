# Rails STI using Rails Enums

Having used Rails STI many times, I came to wonder if it was possible (not necessarily feasible or in any way sane) to use Rails Enum instead of a simple String field for STI type.

It seems it is, although with a tiny tweak to set the type on creation :)

## Initial Ruby and Rails versions

    mkdir rails-sti-enum
    cd rails-sti-enum
    git init

    echo "2.3.0" > .ruby-version

    cat > Gemfile <<-EOF
    source 'https://rubygems.org'
    ruby '2.3.0'

    gem 'rails', '>= 5.0.0.rc1', '< 5.2'
    EOF
    git add .ruby-version Gemfile
    git commit -m "initial commit"

    bundle install
    git add Gemfile.lock
    git commit -m "initial gems"

## Create the Rails application

    bundle exec rails new .
    git add .
    git commit -m "rails new"

## Create a model to play with

    bin/rails g model Animal name type:integer
    bin/rails db:migrate

Create a few other models;

    mkdir app/models/animal
    cat > app/models/animal/cat.rb <<-EOF
    class Animal::Cat < Animal
    end
    EOF

    cat > app/models/animal/dog.rb <<-EOF
    class Animal::Dog < Animal
    end
    EOF

Enable Enums as STI type in `app/models/animal.rb`

    class Animal < ApplicationRecord
      before_create :set_type
      enum type: ['Animal::Cat', 'Animal::Dog']

      private

      # Unfortunately type is not set by rails...
      def set_type
        self.type = self.class.name
      end
    end

## Check it works

    bin/rails c

    Animal::Cat.create name: 'Meow'
    # => #<Animal::Cat id: 1, name: "Meow", type: "Animal::Cat", created_at: "2016-06-09 17:51:51", updated_at: "2016-06-09 17:51:51">

    Animal::Dog.create name: 'Woof'
    # => #<Animal::Dog id: 2, name: "Woof", type: "Animal::Dog", created_at: "2016-06-09 17:51:54", updated_at: "2016-06-09 17:51:54">

    Animal.create
    # => ArgumentError: 'Animal' is not a valid type

    Animal.first
    # => #<Animal::Cat id: 1, name: "Meow", type: "Animal::Cat", created_at: "2016-06-09 17:51:51", updated_at: "2016-06-09 17:51:51">
