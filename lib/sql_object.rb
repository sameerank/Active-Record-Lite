require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map { |col_name| col_name.to_sym}
    SELECT
      *
    FROM
      #{table_name}
    SQL
  end

  def self.finalize!
    columns.each do |col|
      define_method("#{col}") { attributes[col] }
      define_method("#{col}=") { |val| attributes[col] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name = self.to_s.tableize
    @table_name = "humans" if @table_name == "humen"
    @table_name
  end

  def self.all
    parse_all(DBConnection.execute(<<-SQL))
      SELECT
        *
      FROM
        #{table_name}
    SQL
  end

  def self.parse_all(results)
    results.map { |result| new(result) }
  end

  def self.find(id)
    parse_all(DBConnection.execute(<<-SQL))[0]
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = "#{id}"
    SQL
  end

  def initialize(params = {})
    params.each do |key, val|
      raise "unknown attribute '#{key}'" unless self.class.columns.include?(key.to_sym)
      send("#{key}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |key| send("#{key}") }
  end

  def insert
    col_names = self.class.columns.join(", ")
    n = attribute_values.length
    question_marks = (["?"] * n).join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks})
    SQL

    attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    set_line = self.class.columns.map { |attr_name| "#{attr_name} = ?" }.join(", ")
    DBConnection.execute(<<-SQL, *attribute_values, attributes[:id])
    UPDATE
      #{self.class.table_name}
    SET
      #{set_line}
    WHERE
      id = ?
    SQL
  end

  def save
    if attributes[:id].nil?
      insert
    else
      update
    end
  end
end
