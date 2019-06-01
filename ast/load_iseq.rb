iseq_patch = Module.new do
  def load_iseq(fname)
    File.open(fname){|f| p f.read }
    # p pf = RubyVM::AbstractSyntaxTree.parse_file(fname)
    RubyVM::InstructionSequence.compile_file(fname)
  end
end
RubyVM::InstructionSequence.singleton_class.prepend(iseq_patch)

require_relative "foo"
# foo.rb を以下の内容で保存しておく
# class Foo
#   def foo
#     @foo = "foo!!!"
#   end
# end
# Foo.new.foo
