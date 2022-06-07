require "test_helper"

class TaskControllerTest < ActionDispatch::IntegrationTest
  test "teste" do
    get "http://localhost/execute", headers: { 'X-Appengine-Cron': true }
  end

end
