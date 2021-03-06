# インスタンス変数へ代入された行を調べるコード
# 制限事項: 多重代入で動かない 例: @a, @b = 1, 2
## 「Node IVAR + 代入」 を検知すれば多重代入含めて全て検知できるかも？

# TracePointで止めてASTを確認し、インスタンス変数への代入かどうかを調べる
def tracer(target_instance_variable_name:, target_class_name: nil)
  TracePoint.trace(:line) do |tp|
    # puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
    begin
      line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] } # TODO: ファイルがないクラスでは使えない
    rescue Errno::ENOENT => e
      # p "File.open error"
      # p tp
      # p tp.path
    end
    next unless line

    # AST取得
    begin
      node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    rescue Exception => e # 乱暴
      next
    end

    # インスタンス変数への代入かを調べる
    next unless node.type == :IASGN

    # クラス名を調べる
    if target_class_name
      target_class = Kernel.const_get(target_class_name)
      next unless tp.self.is_a?(target_class)
    end

    # インスタンス変数名を調べる
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym

    puts "#{target_class_name} #{target_instance_variable_name} is assigned in #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
    puts "--- caller ---"
    puts caller

    # memo
    # RubyVM::AbstractSyntaxTree.parse(line) #=> RubyVM::AbstractSyntaxTree:Node
    #=> (SCOPE@1:0-1:14
    # tbl: []
    # args: nil
    # body: (IASGN@1:4-1:14 :@hi (STR@1:10-1:14 "hi")))
    # RubyVM::AbstractSyntaxTree.parse(line).children.last
    #=> (IASGN@1:4-1:14 :@hi (STR@1:10-1:14 "hi"))
    # RubyVM::AbstractSyntaxTree.parse(line).children.last #=> RubyVM::AbstractSyntaxTree::Node
  end
end

module Greeting
  def egao(text)
    @greeting = text + "(｡･ω･｡)ノ"
  end
end

class User
  include Greeting
  def hi
    @hi = "hi"
    egao "hi"
  end
end

tracer(target_instance_variable_name: "@hi", target_class_name: "User")
#tracer(target_instance_variable_name: "@greeting", target_class_name: "User")
p User.new.hi
