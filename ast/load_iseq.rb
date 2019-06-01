# RubyVM::InstructionSequence#load_iseq を使うと require 時にフックを挟める
# しかもそこでASTをいじると、変更結果のASTで以降の処理が実行される
# https://qiita.com/hanachin_/items/8aa4bd82258bb19b7f91
# https://magazine.rubyist.net/articles/0053/0053-YarvManiacs.html
iseq_patch = Module.new do
  def load_iseq(fname)
    p fname
    p pf = RubyVM::AbstractSyntaxTree.parse_file(fname)
    p pf.children
    p pf.children.last.children
    p pf.children.last.children.first.children
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
