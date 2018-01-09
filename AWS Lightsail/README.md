## 멋쟁이사자처럼 프로젝트 실습 22일차

### 오늘은 AWS 클라우드 서비스를 배우도록 하겠습니다 !



### 1.  사용할 프로젝트 선택

>- 본인의 GitHub에 프로젝트 Repository가 있어야 한다.
>- 개인 프로젝트가 없는 사람은 [fake_insta](https://github.com/classtak/fake_insta)를 fork 해서 사용하자.

### 2. Figaro( 중요 ! )

>각종 중요한 정보들이 외부에 노출되지 않도록 관리해주는 gem  !
>
>1. Gemfile에 figaro를 추가
>
>```ruby
>gem 'figaro'
>```
>
>2. gem 설치
>
>```
>$ bundle
>```

### 3. Lightsail

>#####1. Lightsail 인스턴스 생성은 쉬우니까 생략하겠습니다 !
>
>#####2. 주의사항
>
>- 인스턴스를 생성한 순간부터 과금이 될 수 있다. 과금 유의사항을 항상 자세히 읽어보기를 권장하며, 사용하지 않을 인스턴스는 바로 삭제를 해주는 것이 좋다.
>
>##### 3. Auto Server Setup Script
>
>3. 1) Auto Server Setup Script 가져오기
>
>```
>$ git clone https://github.com/zzulu/yay-you-are-on-aws.git
>```
>
>3. 2) 실행에 앞서 편의를 위하여 현재 폴더를 변경
>
>```
>$ cd ~/yay-you-are-on-aws
>```
>
>3. 3) rbenv.sh 실행
>
>서버 설정을 매우 편리하게 해주기 위하여 `scrpit`를 미리 작성하였음 ! 아까 받은 `script`를 실행하면 모든 설정이 자동으로 된다. sh 명령어를 사용하여 실행하자 !
>
>```
>$ sh ./scripts/rbenv.sh
>```
>
>3. 4) shell 새로고침 해주자 !
>
>```
>$ exec $SHELL
>```
>
>3. 5) ruby 설치
>
>`rbenv.sh`를 통해 우리는 Rails 설치 및 실행에 필요한 모든 프로그램과 `rbenv`를 설치해주었다. Ruby의 경우 rbenv를 통해 직접 설치해주어야 한다. 
>
>```
>$ rbenv install 2.3.5
>$ rbenv global 2.3.5 
>$ gem install bundler
>$ rbenv rehash
>```
>
>3. 6) rails 설치
>
>```
>$ gem install rails -v 4.2.9
>```
>
>3. 7) nginx.sh 실행하기
>
>Web Server인 Nginx와 Application Server인 Passenger를 설치하는 script를 실행
>
>```
>$ sh ./scripts/nginx.sh
>```
>
>##### 4. 프로젝트 가져오기
>
>사용할 프로젝트 선택에서 선택한 프로젝트를 Lightsail Instance로 가져온다. 여기서는 [classtak](https://github.com/classtak)의 fake_insta를 가져오지만 각자 개인의 프로젝트를 가져와도 됨 !
>
>```
>$ cd ~
>$ git clone https://github.com/classtak/fake_insta.git
>```
>
>##### 5. Nginx, Passenger 설정하기
>
>5. 1) Passenger 설정하기
>
>```
>$ sudo vi /etc/nginx/passenger.conf
>```
>
>5. 2)  `passenger_ruby` 부분을 다음과 같이 수정한다.
>
>```
>passenger_ruby /home/ubuntu/.rbenv/shims/ruby;
>```
>
>5. 3) Nginx 설정하기
>
>```
>$ sudo vi /etc/nginx/nginx.conf
>
>:set nu -> 줄 번호를 출력해줌 
>```
>
> 아래의 내용을 찾아, `include`로 시작하는 줄을 주석 해제한다.
>
>```
># set nu를 입력했다면 63번째 줄 !
>##
># Phusion Passenger
>##
># Uncomment it if you installed ruby-passenger or ruby-passenger-enterprise
>##
>
>include /etc/nginx/passenger.conf;
>```
>
>파일을 하나 더 수정해야함 !
>
>```
>$ sudo vi /etc/nginx/sites-enabled/default
>```
>
>여기서도 :set nu 를 입력해서 줄 번호를 출력하자 
>
>```
># 우리는 36번째 줄로 가서 
># 숫자 '12' dd 를 입력하여 12번째 줄을 삭제하자 !
>```
>
>파일의 내용을 다음과 같이 수정한다. `fake_insta`는 `3.4.`에서 가져온 프로젝트 이름으로 대체될 수 있다. 
>
> ```
>server {
>        listen 80;
>        listen [::]:80 ipv6only=on;
>        # 여기부터
>        server_name         example.com;
>        passenger_enabled   on;
>        rails_env           production;
>        root                /home/ubuntu/fake_insta/public;
>        # 여기까지 총 4줄 추가
>        # Add index.php to the list if you are using PHP
>        # index index.html index.htm index.nginx-debian.html;
>
>        ## Comment the following block
>        # location / {
>        #   # First attempt to serve request as file, then
>        #   # as directory, then fall back to displaying a 404.
>        #   try_files $uri $uri/ =404;
>        # }
>}
> ```
>
>설정 파일 편집이 완료되었으면 작성이 잘 되었는지 테스트하기 위하여 아래의 명령어를 입력한다.
>
>```
>$ sudo nginx -t
>```
>
>만약 문제가 없다면, 아래의 명령어를 입력하여 Nginx를 실행하자.
>
>```
>$ sudo service nginx start
>```
>
> ##### 6. 가져온 프로젝트 설정하기
>
>우선 가져온 프로젝트 폴더 안으로 이동
>
>```
>$ cd ~
>$ cd fake_insta
>```
>
>gem 파일들을 설치
>
>```
>$ bundle install
>```
>
> `secrets.yml` 파일을 열어보면 production 부분에 secret_key_base가 설정되어 있지 않다. 노출되면 안되는 중요한 정보이기 때문에 Rails가 자동으로 생성하지 않아서 figaro를 이용하여 직접 설정해주어야 한다. figaro를 설치한다.
>
>```
>$ bundle exec figaro install
>```
>
>128자리 난수를 생성하여 `config` 폴더 안의 `application.yml` 파일에 붙인다.
>
>```
>$ rake secret >> ./config/application.yml
>```
>
> `application.yml` 파일을 열어, 128자리 난수 앞에 아래의 코드를 작성한다.
>
>```
>$ vi ./config/application.yml
>
>SECRET_KEY_BASE: (방금 생성한 128자리 난수)
>AWS_ID: (AWS_ID 값)
>AWS_SECRET: (AWS_SECRET 값)
>```
>
>( 이전에 환경변수에 AWS id, secret 값을 저장 했을 때)
>
>```
>$ printenv | grep AWS 
># 입력 하면 env에 저장된 aws이름의 변수 값들을 출력해줌 !
>```
>
> `production` 환경으로 Database를 생성한다.
>
>```
>$ RAILS_ENV=production rake db:migrate
>```
>
> production 환경에서는 precompile된 assets들을 사용하기 때문에 precompile된 파일들을 따로 생성해주어야 한다. 아래의 명령어로 생성을 한다.
>
>```
>$ RAILS_ENV=production rake assets:precompile
>```
>
>아래의 명령어로 프로젝트를 refresh 한다.
>
>```
># 처음 시작할 때면
>$ sudo service nginx restart
># 이후에는 
>$ touch tmp/restart.txt
>```
>
>Lightsail의 IP 주소를 브라우저 주소창에 입력하여 사이트에 접속이 되는지 확인한다.

### 4. S3

>1. S3 Bucket 만들기
>
>이미지가 올라갈 버킷을 만든다. 버킷의 이름을 지정하고, 리전을 **아시아 태평양(서울)**로 설정하고 버킷을 생성한다
>
>2. Gemfile 추가하기
>
>```ruby
># Gemfile에 추가
>gem 'fog' 
>```
>
>2. 2) gem 설치
>
>```
>$ bundle install
>```
>
>3. fog-aws.rb 
>
>`config/initializers` 폴더에 `fog-aws.rb`라는 이름의 파일을 만들어 준다. 내용은 다음과 같다.
>
>```ruby
>CarrierWave.configure do |config|
>  config.fog_credentials = {
>    provider:              'AWS',
>    aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
>    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
>    region:                'ap-northeast-2'
>  }
>  config.fog_directory  = '앞서 설정한 bucket 이름'
>end
>```
>
>4. Uploader
>
>`post_image_uploader.rb` 파일을 다음과 같이 수정한다.
>
>```ruby
># Choose what kind of storage to use for this uploader:
>storage :file
># storage :fog
>
># 아래와 같이 변경
>
># Choose what kind of storage to use for this uploader:
># storage :file
>storage :fog
>```
>
>S3에 이미지를 올리기 위한 모든 설정을 완료하였다. 새로운 게시글을 작성해보고 이미지가 S3 버킷에 잘 저장되는지 확인해보자 !
>
> 



