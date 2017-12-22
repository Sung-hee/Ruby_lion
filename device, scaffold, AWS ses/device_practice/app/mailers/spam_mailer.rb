class SpamMailer < ApplicationMailer
  default from: "klpoik326@gmail.com"

  def hiodk410(receiver, title, content)
    @text = content
     mail(to: receiver, subject: title)

  end
end
