require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Post의 타이틀은 두 글자 이상이어야 한다" do
    post = Post.new(title: "ad")
    assert post.save
  end
end
