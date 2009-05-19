require File.dirname(__FILE__) + '/../test_helper'
require 'albumcomment_controller'

# Re-raise errors caught by the controller.
class AlbumcommentController; def rescue_action(e) raise e end; end

class AlbumcommentControllerTest < Test::Unit::TestCase
  def setup
    @controller = AlbumcommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
