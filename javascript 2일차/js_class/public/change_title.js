// // alert("여기는 인덱스 페이지 입니다.")
// // 1. 이벤트를 넣어줄 html element찾고
// var btn = document.getElementById('change-title');
// // 2. 해당 element에 원하는 이벤트를 달아준다.
// btn.onclick = function() {
//   // 3. 이벤트가 발생했을 경우 실행하는 함수(function())를 만들어준다.
//   // 실행문
//   // 버튼을 누르면 prompt창이 떠서 입력메세지를 입력할 수 있고,
//   // 해당 내용으로 모든 제목을 바꿔버립니다.
//   var title = prompt('바꿀 제목을 입력하세요.');
//   // 바꿀 내용물들(html element)이 어디에 있는지 찾아야함.
//   // getElement*** -> 내용물을 1개만 가지고 온다. -> 여러개 있어도 return값은 1개
//   // getElements*** -> 내용물들을 여러개 가지고 온다. -> 1개만 있어도 return값은 배열
//   // getElements***로 찾은 html element를 사용할 때에는 반복문, 혹은 index로 하나씩 조정
//   var titles = document.getElementsByClassName('title');
//
//   for(var i = 0; i < titles.length; i++) {
//     // 해당 내용으로 모든 제목을 바꿔버립니다.
//     titles[i].textContent = title;
//   }
// }
$(document).ready(function(){
  $('#change-title').click(function(){
    var title = prompt('바꿀 제목을 입력하세요.');
      $('.title').text(title);
  })
})
