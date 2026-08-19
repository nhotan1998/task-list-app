require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "task rejects files larger than 10MB" do
    task = Task.new(
      title: "Large file",
      due_date: Time.current + 1.day,
      user: users(:one)
    )

    file = Tempfile.new(["big", ".txt"])
    file.binmode
    file.write("a" * (11 * 1024 * 1024))
    file.rewind

    task.files.attach(
      io: file,
      filename: "big.txt",
      content_type: "text/plain"
    )

    assert_not task.valid?
    assert_includes task.errors[:files], "must be less than or equal to 10MB"
  ensure
    file.close
    file.unlink
  end
end
