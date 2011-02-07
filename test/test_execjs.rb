require "execjs"
require "test/unit"

class TestExecJS < Test::Unit::TestCase
  def test_exec
    assert_equal true, ExecJS.exec("return true")
  end

  def test_eval
    assert_equal ["red", "yellow", "blue"], ExecJS.eval("'red yellow blue'.split(' ')")
  end

  def test_runtime_available
    runtime = ExecJS::Runtime.new(:command => "nonexistent")
    assert_equal false, runtime.available?

    runtime = ExecJS::Runtime.new(:command => "ruby")
    assert_equal true, runtime.available?
  end
end