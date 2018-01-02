// tr에 해당하는 부분을 click 하면
// '현재' click 한 부분의 id가 몇인지 파악해야함.
var table = document.getElementsByTagName('tr');

for(var i = 0; i < table.length; i++){
  table[i].onclick = function(){
    var show = (this.getAttribute('hoho'));
    window.location.href = "/boards/" + show;
  }
}
// btn.onclick = function() {
//
// }
// show페이지를 이동한다.
// Location.href = '???';
