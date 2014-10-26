defmodule RcFileTest do
  use ExUnit.Case

  setup do
    TestHelper.cleanup
    on_exit fn -> TestHelper.cleanup end
  end  

  test "that rc file is created when it doesn't exist" do
    assert !File.exists?(TestHelper.path)
    TestHelperTask.run(["initrc"])
    assert File.exists?(TestHelper.path)
  end

  test "that rc file contains expected values" do
    TestHelperTask.run(["initrc"])

    content = File.read! TestHelper.path
    assert String.contains?(content, "a: A")
    assert String.contains?(content, "b: false")
  end
end
