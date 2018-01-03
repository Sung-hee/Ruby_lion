class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :board

  def require_permisson?(user)
    self.user.id == user.id
  end
end
