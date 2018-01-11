class Post < ActiveRecord::Base
  validates :title, presence: true,
                    length: { minimun: 2 }
  # validates :content
end
