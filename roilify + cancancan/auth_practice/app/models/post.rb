class Post < ActiveRecord::Base
  resourcify
  belongs_to :user
end
