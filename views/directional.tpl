%def styles():
  <style type="text/css">
    .gauge {
      color: #000000;
      background-color: #CCCCCC;
      border: solid 1px #000000;
    }

    .bt {
      color: #FFFFFF;
      background-color: #5555FF;
      border: solid 1px #000000;
    }

    .toggle {
      color: #000000;
      background-color: #55FF55;
      border: solid 1px #000000;
    }

    .toggle.toggle-on {
      color: #FFFFFF;
      background-color: #FF5555;
    }

    .absolute {
      position: absolute;
      cursor: pointer;
      cursor: hand;
    }

    .center-text {
      display: table;
      text-align: center;
    }

    .center-text > span {
      display: table-cell;
      vertical-align: middle;
    }

    #updown    { left: 15px; top: 30px; bottom: 30px; width: 50px; }
    #leftright { left: calc(100% - 250px); top: calc(100% - 172px); right: 15px; bottom: 30px; height: 50px; }
    #connect   { left: calc(100% - 250px); top: calc(100% - 102px); right: 15px; bottom: 30px; height: 35px; }
    #kpp        { left: 150px; top: 30px; width: 35px; height: 35px; }
    #kip        { left: 200px; top: 30px; width: 35px; height: 35px; }
    #kdp        { left: 250px; top: 30px; width: 35px; height: 35px; }
    #spp        { left: 300px; top: 30px; width: 35px; height: 35px; }
    #kpm        { left: 150px; top: 80px; width: 35px; height: 35px; }
    #kim        { left: 200px; top: 80px; width: 35px; height: 35px; }
    #kdm        { left: 250px; top: 80px; width: 35px; height: 35px; }
    #spm        { left: 300px; top: 80px; width: 35px; height: 35px; }
    #agr        { left: 350px; top: 30px; width: 45px; height: 85px; }

  </style>
%end

%def scripts():
  <script>
    var sendEvent = function(name, arg) {
      $.get('/event/' + name + '/' + arg + '/', function(data) {
        console.log(data);
      });
    };

    var onTap = function(elem, callback) {
      var hm = new Hammer.Manager(elem);
      hm.add(new Hammer.Tap());
      hm.on('tap', function(e) {
        callback(e);
      });
    };

    $(function() {
      onTap($('#kpp').get(0), function(e) {
        sendEvent('kp', '+');
      });

      onTap($('#kip').get(0), function(e) {
        sendEvent('ki', '+');
      });

      onTap($('#kdp').get(0), function(e) {
        sendEvent('kd', '+');
      });

      onTap($('#spp').get(0), function(e) {
        sendEvent('sp', '+');
      });

      onTap($('#kpm').get(0), function(e) {
        sendEvent('kp', '-');
      });

      onTap($('#kim').get(0), function(e) {
        sendEvent('ki', '-');
      });

      onTap($('#kdm').get(0), function(e) {
        sendEvent('kd', '-');
      });

      onTap($('#spm').get(0), function(e) {
        sendEvent('sp', '-');
      });

      var agr = $('#agr');

      onTap(agr.get(0), function(e) {
        if(agr.hasClass('toggle-on')) {
          agr.removeClass('toggle-on')
          sendEvent('agr', 'off');
        } else {
          agr.addClass('toggle-on')
          sendEvent('agr', 'on');
        }
      });

      $('#connectBt').on('click', function(e) {
        $.get('/connect/' + $('#addr').val() + '/', function(data) {
          console.log(data);
        });
      });
    });

    $(function() {
      var last = 0;

      var hm = new Hammer.Manager($('#updown').get(0));

      hm.add(new Hammer.Pan({
        direction: Hammer.DIRECTION_VERTICAL,
        threshold: 0
      }));

      hm.on('pan', function(e) {
        var y = 1 - (e.center.y - e.target.offsetTop) / e.target.offsetHeight;
        y = y > 1 ? 1 : (y < 0 ? 0 : y);
        if(Math.abs(last - y) > 0.05) {
          last = y;
          sendEvent('updown', last);
        }
      });

      hm.on('panend', function() {
        last = 0.5;
        sendEvent('updown', last);
      });
    });

    $(function() {
      var last = 0;

      var hm = new Hammer.Manager($('#leftright').get(0));

      hm.add(new Hammer.Pan({
        direction: Hammer.DIRECTION_HORIZONTAL,
        threshold: 0
      }));

      hm.on('pan', function(e) {
        var x = (e.center.x - e.target.offsetLeft) / e.target.offsetWidth;
        x = x > 1 ? 1 : (x < 0 ? 0 : x);
        if(Math.abs(last - x) > 0.05) {
          last = x;
          sendEvent('leftright', last);
        }
      });

      hm.on('panend', function() {
        last = 0.5;
        sendEvent('leftright', last);
      });
    });

  </script>
%end

%rebase('layouts/master.tpl', title='BT Controller')

<div id="kpp" class="absolute center-text bt"><span>KP+</span></div>
<div id="kip" class="absolute center-text bt"><span>KI+</span></div>
<div id="kdp" class="absolute center-text bt"><span>KD+</span></div>
<div id="spp" class="absolute center-text bt"><span>SP+</span></div>
<div id="kpm" class="absolute center-text bt"><span>KP-</span></div>
<div id="kim" class="absolute center-text bt"><span>KI-</span></div>
<div id="kdm" class="absolute center-text bt"><span>KD-</span></div>
<div id="spm" class="absolute center-text bt"><span>SP-</span></div>
<div id="agr" class="absolute center-text toggle"><span>Agr</span></div>

<div id="updown" class="absolute gauge"></div>
<div id="leftright" class="absolute gauge"></div>

<div id="connect" class="absolute">
  <input id="addr" style="width: 60%; height: 100%" type="text" value="98:D3:31:40:22:FF">
  <button id="connectBt" style="width: 36%; height: 100%">Connect</button>
</div>

<textarea id="console"></textarea>
