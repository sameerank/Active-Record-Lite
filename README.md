# Active Record Lite

An ORM inspired by the functionality of ActiveRecord

## Features
  * Uses metaprogramming in Ruby to make SQL commands that query a relational database.
  * The SQLObject class interacts with the database in a manner similar to `ActiveRecord::Base`:
    * `::all`: return an array of all the records in the DB
    * `::find`: look up a single record by primary key
    * `#insert`: insert a new row into the table to represent the `SQLObject`.
    * `#update`: update the row with the `id` of this `SQLObject`
    * `#save`: convenience method that either calls `insert`/`update` depending on whether or not the `SQLObject` already exists in the table.
  * Two modules mixin to the SQLObject class using `extend`: `Searchable` and `Associatable`
    * `Searchable` adds the ability to search using `::where`.
    * `Associatable` defines `belongs_to`, `has_many`, and `has_one_through`.

## One way to use this:
  * Open a pry or irb session within the Active Record Lite directory
  * Type `require './lib/associatable'`. This will include all the 
