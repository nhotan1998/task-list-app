require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @task = tasks(:one)
    post login_url, params: { email: @user.email, password: "password123" }
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_task_url
    assert_response :success
  end

  test "new form includes required task fields and multipart upload" do
    get new_task_url
    assert_response :success
    assert_select "form[action='#{tasks_path}'][enctype='multipart/form-data']" do
      assert_select "input[name='task[title]']"
      assert_select "textarea[name='task[description]']"
      assert_select "input[name='task[due_date]']"
      assert_select "input[name='task[completed]'][type='checkbox']"
      assert_select "input[name='task[files][]'][type='file']"
    end
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, params: { task: { completed: @task.completed, description: @task.description, due_date: @task.due_date, title: @task.title } }
    end

    assert_redirected_to task_url(Task.last)
  end

  test "should create task with uploaded file" do
    file = Tempfile.new(["attachment", ".txt"])
    file.write("hello upload")
    file.rewind

    assert_difference("Task.count") do
      post tasks_url, params: {
        task: {
          title: "Upload test",
          description: "with file",
          due_date: Time.current + 1.day,
          completed: false,
          files: [Rack::Test::UploadedFile.new(file.path, "text/plain")]
        }
      }
    end

    created_task = Task.last
    assert created_task.files.attached?
    assert_equal "hello upload", created_task.files.first.blob.download
  ensure
    file.close
    file.unlink
  end

  test "should show task" do
    get task_url(@task)
    assert_response :success
  end

  test "should display uploaded files on task show page" do
    file = Tempfile.new(["attachment", ".txt"])
    file.write("hello upload")
    file.rewind

    @task.files.attach(io: file, filename: "sample.txt", content_type: "text/plain")

    get task_url(@task)
    assert_response :success
    assert_select ".task-attachments a", text: /sample.txt/
  ensure
    file.close
    file.unlink
  end

  test "should get edit" do
    get edit_task_url(@task)
    assert_response :success
  end

  test "should update task" do
    patch task_url(@task), params: { task: { completed: @task.completed, description: @task.description, due_date: @task.due_date, title: @task.title } }
    assert_redirected_to task_url(@task)
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end
end
