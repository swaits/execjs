require "execjs"
require "test/unit"

module TestRuntime
  def test_exec
    assert_nil @runtime.exec("1")
    assert_nil @runtime.exec("return")
    assert_nil @runtime.exec("return null")
    assert_nil @runtime.exec("return function() {}")
    assert_equal 0, @runtime.exec("return 0")
    assert_equal true, @runtime.exec("return true")
    assert_equal [1, 2], @runtime.exec("return [1, 2]")
    assert_equal "hello", @runtime.exec("return 'hello'")
    assert_equal({"a"=>1,"b"=>2}, @runtime.exec("return {a:1,b:2}"))
  end

  def test_eval
    assert_nil @runtime.eval("")
    assert_nil @runtime.eval(" ")
    assert_nil @runtime.eval("null")
    assert_nil @runtime.eval("function() {}")
    assert_equal 0, @runtime.eval("0")
    assert_equal true, @runtime.eval("true")
    assert_equal [1, 2], @runtime.eval("[1, 2]")
    assert_equal "hello", @runtime.eval("'hello'")
    assert_equal({"a"=>1,"b"=>2}, @runtime.eval("{a:1,b:2}"))
  end

  def test_syntax_error
    assert_raise ExecJS::RuntimeError do
      @runtime.exec(")")
    end
  end

  def test_thrown_exception
    assert_raise ExecJS::ProgramError do
      @runtime.exec("throw 'hello'")
    end
  end
end

def test_runtime(name)
  runtime = ExecJS::Runtimes.const_get(name)
  if runtime.available?
    Class.new(Test::Unit::TestCase) do
      (class << self; self end).send(:define_method, :name) do
        "#{name}Test"
      end

      include TestRuntime

      define_method(:setup) do
        instance_variable_set(:@runtime, runtime)
      end
    end
  else
    warn "#{name} runtime is unavailable, skipping"
  end
end

test_runtime :JSC
test_runtime :Node
test_runtime :Spidermonkey
test_runtime :V8