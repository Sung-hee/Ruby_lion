## 멋쟁이사자처럼 프로젝트 실습 20일차

#### 오늘도 실습은 Atom으로 그리고 나는 지각!



### 오늘은 새로운 프로젝트를 만들어 부트스트랩 연습을 할꺼임 !

>1. 새로운 프로젝트 만들기!
>
>```ruby
># 프로젝트 만들기
>$ rails new bs_template --skip-bundle
># 컨트롤러 만들기
>$ rails g controller home index 
>```
>
>2. routes.rb 수정하기
>
>```ruby
>root 'home#index'
>```
>
>3. Gem 추가하기
>
>```ruby
>gem 'bootstrap', '~> 4.0.0.beta3'
>gem 'font-awesome-rails'
>gem 'simple-line-icons-rails'
>
>$ bundle install
>```
>
>4. 부트스트랩 추가하기
>
>```javascript
>// 1. assets -> javascripts -> application.js
>코드 추가 이건 '//' 까지 추가해야됨 !
>//= require popper
>//= require bootstrap
>
>// 2. assets -> stylesheets -> application.css 
>1) 먼저 application.css -> application.scss 로 변경
>2) 그리고 bootstrap 임포트해주기 !
>@import 'bootstrap';
>@import 'font-awesome';
> 
>// 3. views -> layouts -> application.html.erb
><meta charset="utf-8">
><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
>```
>
>5. css파일 옮기기 !
>
>```ruby
><link rel="stylesheet" href="../../assets/vendor/icon-line/css/simple-line-icons.css">
><link rel="stylesheet" href="../../assets/vendor/icon-line-pro/style.css">
><link rel="stylesheet" href="../../assets/vendor/icon-hs/style.css">
><link rel="stylesheet" href="../../assets/vendor/animate.css">
><link rel="stylesheet" href="../../assets/vendor/hs-megamenu/src/hs.megamenu.css">
><link rel="stylesheet" href="../../assets/vendor/hamburgers/hamburgers.min.css">
><link rel="stylesheet" href="../../assets/vendor/chosen/chosen.css">
><link rel="stylesheet" href="../../assets/vendor/slick-carousel/slick/slick.css">
><link rel="stylesheet" href="../../assets/vendor/fancybox/jquery.fancybox.min.css">
>```
>
>6. import 추가하기 !
>
>```javascript
>// assets -> stylesheets -> application.css 
>@import 'icon-line-pro/style';
>@import 'icon-hs/style';
>@import 'animate';
>@import 'hs.megamenu';
>@import 'hamburgers';
>@import 'chosen';
>@import 'slick';
>@import 'jquery.fancybox';
>@import 'styles.multipage-real-estate';
>```
>
>7. font 추가하기
>
>```ruby
>1. public 폴더 -> fonts 폴더추가 -> finance 폴더만들기
>2. public 폴더 -> fonts 폴더추가 -> communication-48-x-48 폴더만들기
>3. public 폴더 -> fonts 폴더추가 -> real-estate 폴더 만들기
>4. public 폴더 -> fonts 폴더추가 -> hs-icons 폴더 만들기
># 그리고 해당 파일들을 옮기자 ! 부트스트랩이라 자세한 설명은 하지 않겠음 !
>4. vendor 폴더에서 마우스 오른쪽 클릭 후 search 로 finance 검색 !
>그리고 url을 클릭하고 /*Finance*/에서 url -> font_url로 변경
>또한 파일경로를 finance/finance로 변경해주자 !
>5. real-estate, communication-48-x-48, hs-icons도 똑같이 바꿔주자 !
>
>$ rake assets:precompile
>```
>
>8. javascript 추가하기
>
>```ruby
>$ gem 'jquery-migrate-rails'
>
># app -> assets -> javascripts -> application.js 폴더에
>//= require jquery
>//= require jquery-migrate-min # -> 요놈 추가
>//= require jquery_ujs
>
>그리고 css 파일처럼 똑같이 파일들을 옮기자 !
>
># app -> assets -> javascripts -> application.js 폴더에
>//= require hs.megamenu
>//= require widget
>//= require widgets/menu
>//= require widgets/mouse
>//= require widgets/slider
>//= require chosen.jquery
>//= require slick
>//= require jquery.fancybox
>//= require hs.core
>//= require components/hs.header
>//= require helpers/hs.hamburgers
>//= require components/hs.dropdown
>//= require components/hs.slider
>//= require components/hs.select
>//= require components/hs.carousel
>//= require components/hs.popup
>//= require components/hs.go-to
>
>추가하고 아래의 명령어들을 실행하자 !
>$ rake assets:clobber 
>$ rake assets:precompile
>```
>
>오늘은 계속 이짓을 반복해서 올릴게 없음 ..
