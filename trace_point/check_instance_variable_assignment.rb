def trace_start
  TracePoint.trace(:line) do |tp|
    target_class_name = "Foo"
    target_instance_variable_name = "@bar"

    line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    node = RubyVM::AbstractSyntaxTree.parse(line).children.last

    # check instance variable assignment
    next unless node.type == :IASGN

    # check class name
    target_class = Kernel.const_get(target_class_name)
    next unless tp.self.is_a?(target_class)

    # check variable name
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym

    puts "#{target_class_name} #{target_instance_variable_name} is assigned in #{tp.path}:#{tp.lineno} #{tp.defined_class} #{tp.method_id}"
  end
end

class Foo
  def bar
    @bar = "text"
  end
end

trace_start
Foo.new.bar
#=> Foo @bar is assigned in check_instance_variable_assignment.rb:25 Foo bar

