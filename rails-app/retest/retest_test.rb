require_relative 'test_helper'
require 'minitest/autorun'

$stdout.sync = true

include FileHelper

class RailsTest < Minitest::Test
  def teardown
    end_retest @output, @pid
  end

  def test_modifying_existing_file
    @output, @pid = launch_retest

    modify_file('app/controllers/posts_controller.rb')

    assert_match "Test File Selected: test/controllers/posts_controller_test.rb", @output.read
    assert_match /7 runs, 9 assertions, 0 failures, 0 errors, 0 skips/, @output.read
  end

  def test_modifying_existing_test_file
    @output, @pid = launch_retest

    modify_file('test/controllers/posts_controller_test.rb')

    assert_match "Test File Selected: test/controllers/posts_controller_test.rb", @output.read
    assert_match /7 runs, 9 assertions, 0 failures, 0 errors, 0 skips/, @output.read
  end

  def test_creating_a_new_test_file
    @output, @pid = launch_retest

    create_file 'test/controllers/comments_controller_test.rb'

    assert_match "Test File Selected: test/controllers/comments_controller_test.rb", @output.read

    delete_file 'test/controllers/comments_controller_test.rb'
  end

  def test_creating_a_new_file
    @output, @pid = launch_retest

    create_file 'app/controllers/authors_controller.rb'
    assert_match <<~EXPECTED, @output.read
      404 - Test File Not Found
      Retest could not find a matching test file to run.
    EXPECTED

    create_file 'test/controllers/authors_controller_test.rb'
    assert_match "Test File Selected: test/controllers/authors_controller_test.rb", @output.read

    modify_file('test/controllers/posts_controller_test.rb')
    assert_match "Test File Selected: test/controllers/posts_controller_test.rb", @output.read

    modify_file('test/controllers/authors_controller.rb')
    assert_match "Test File Selected: test/controllers/authors_controller_test.rb", @output.read

    delete_file 'app/controllers/authors_controller.rb'
    delete_file 'test/controllers/authors_controller_test.rb'
  end

  def test_untracked_file
    create_file 'app/controllers/authors_controller.rb', should_sleep: false
    create_file 'test/controllers/authors_controller_test.rb', should_sleep: false

    @output, @pid = launch_retest

    modify_file 'app/controllers/authors_controller.rb'
    assert_match "Test File Selected: test/controllers/authors_controller_test.rb", @output.read

    delete_file 'app/controllers/authors_controller.rb'
    delete_file 'test/controllers/authors_controller_test.rb'
  end
end
