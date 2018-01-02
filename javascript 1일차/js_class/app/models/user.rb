class User < ActiveRecord::Base
  # 암호화된 비밀번호를 가지고 있습니다 !
  # 이것을 통해서 password_digest에 저장할 수 있음.
  has_secure_password

  has_many :boards
end
