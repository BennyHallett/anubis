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
end
