class Board < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :comments
  # default 값은 25 인데 한 페이지당 글을 50개로 늘린다.
  paginates_per 50
  def require_permisson?(user)
    self.user.id == user.id
  end
end
