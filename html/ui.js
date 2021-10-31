var warenkorb = []

$(document).ready(function(){
    window.addEventListener('message', function( event ) {      
      if (event.data.action == 'open') {

        const warenkorb1 = document.getElementById("warenkorb-list");
        warenkorb1.innerHTML = '';
        warenkorb = []

        $('#warenkorb-1').text('$0.0');
        $('#warenkorb-2').text('$0.0');

        $('.container').fadeIn(300)        
        $('.container').css('display', 'block');        

      } else if (event.data.action == 'add') {
                
        AddItem(event.data.name, event.data.display, event.data.price);       

      } else {
        $('.container').fadeOut(300)
      }
    });

    $( ".close" ).click(function() {
      $('.container').fadeOut(300)
      $.post('http://police_shop/escape', JSON.stringify({}));
    });
});

function AddWarenkorb(name, display, price) {
  warenkorb.push({name: name, display: display, price: price});

  $(".warenkorb-list").append
  (`
    <div class="warenkorb-list-elem">
        <p><span style="font-size:20px;">1x</span>   `+ display +`  <span style="color:#40c240">$`+ price +`</p>
    </div>
  `);

  var current = $('#warenkorb-1').text();
  var current2 = current.replace("$", "");
  var int = parseFloat(current2)
  
  $('#warenkorb-1').text('$' + (int + parseFloat(price)));

  var xcurrent = $('#warenkorb-1').text();
  var xcurrent2 = xcurrent.replace("$", "");
  var xint = parseFloat(xcurrent2)

  $('#warenkorb-2').text('$' + (xint + (xint * 0.00)));
}

function buy() {
  $.post('http://police_shop/buy', JSON.stringify({warenkorb: warenkorb}));
  $('.container').fadeOut(300)
  $.post('http://police_shop/escape', JSON.stringify({}));
  warenkorb = []
}

function AddItem(name, display, price) {
  $("#items-content").append
      (`
      
      <div class="items-element">
          <div class="items-element-inner" style="background-image: url(items/`+name+`.png);">

          </div>
          <div class="items-element-sub" onclick="AddWarenkorb('`+name+`', '`+display+`', '`+price+`')">
              $`+price+`
          </div>
      </div>
      `);
}