require 'bundler/setup'
require 'stamp'

# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done, :due_date

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    result = "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
    result += due_date.stamp(' (Due: Friday January 6)') if due_date
    result
  end
end

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(task)
    raise TypeError, 'Can only add Todo objects' unless task.instance_of?(Todo)
    @todos << task
    @todos
  end

  alias_method :<<, :add

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def item_at(position)
    @todos.fetch(position)
  end

  def mark_done_at(position)
    item_at(position).done!
  end

  def mark_undone_at(position)
    item_at(position).undone!
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def remove_at(position)
    @todos.delete(item_at(position))
  end

  def to_s
    text = "# ---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def to_a
    @todos.to_a
  end

  def done!
    @todos.each_index { |idx| mark_done_at(idx) }
  end

  def done?
    @todos.all? { |task| task.done? }
  end

  def each
    @todos.each { |task| yield(task) }
    self
  end

  def select
    new_list = TodoList.new(title)
    each { |task| new_list << task if yield(task) }
    new_list
  end

  def find_by_title(string)
    each { |task| return task if task.title == string }
    nil
  end

  def all_done
    select { |task| task.done? }
  end

  def all_not_done
    select { |task| !task.done? }
  end

  def mark_done(string)
    find_by_title(string) && find_by_title(string).done!
  end

  def mark_all_done
    each { |task| task.done! }
  end

  def mark_all_undone
    each { |task| task.undone! }
  end
end
