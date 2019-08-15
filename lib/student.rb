require_relative "../config/environment.rb"
require "pry"
class Student
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)
      idnumarray = DB[:conn].execute("SELECT last_insert_rowid() FROM students")
      @id = idnumarray.flatten[0]
    end
  end

  def self.create(name, grade)
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
    DB[:conn].execute(sql, name, grade)
  end

  def self.new_from_db(row)
    flatrow = row.flatten
    student = Student.new(flatrow[1], flatrow[2], flatrow[0])
    return student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? ORDER BY name LIMIT 1;"
    student = DB[:conn].execute(sql, name)
    self.new_from_db(student)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


end
