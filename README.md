# Active Record Lite

An ORM inspired by the functionality of Active Record, which is the M (the model) in MVC and therefore the layer of the system responsible for representing business data and logic. Like Active Record, this ORM facilitates the creation and use of business objects whose data requires persistent storage to a database.

## Features
  * Uses metaprogramming in Ruby to make SQL commands that query a relational database.
  * The SQLObject class interacts with the database in a manner similar to `ActiveRecord::Base`:
    * `::all`: returns an array of all the records in the DB
    * `::find`: looks up a single record by primary key
    * `#insert`: inserts a new row into the table to represent the `SQLObject`.
    * `#update`: updates the row with the `id` of this `SQLObject`
    * `#save`: a convenience method that either calls `insert`/`update` depending on whether or not the `SQLObject` already exists in the table.
  * Two modules mixin to the SQLObject class using `extend`: `Searchable` and `Associatable`
    * `Searchable` adds the ability to search using `::where`.
    * `Associatable` defines `belongs_to`, `has_many`, and `has_one_through`.

## One way to use this:
  * Open a pry or irb session within the Active Record Lite directory
  * Type `require './lib/associatable'`. This file requires `searchable`, which in turn also requires `sql_object`. Therefore, requiring this file will mixin all the modules that extend `SQLObject`.
  * ![Alt text](1.png?raw=true "Title")
  * Next, set up the model classes that correspond to the example database's tables.
  * ![Alt text](2.png?raw=true "Title")
