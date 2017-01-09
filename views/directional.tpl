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

    .absolute {
      position: absolute;
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
    #f1        { left: 150px; top: 30px; width: 50px; height: 50px; }
    #f2        { left: 220px; top: 30px; width: 50px; height: 50px; }
    #f3        { left: 290px; top: 30px; width: 50px; height: 50px; }

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
      onTap($('#f1').get(0), function(e) {
        sendEvent('f1', 0);
      });

      onTap($('#f2').get(0), function(e) {
        sendEvent('f2', 0);
      });

      onTap($('#f3').get(0), function(e) {
        sendEvent('f3', 0);
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

<div id="f1" class="absolute center-text bt"><span>F1</span></div>
<div id="f2" class="absolute center-text bt"><span>F2</span></div>
<div id="f3" class="absolute center-text bt"><span>F3</span></div>

<div id="updown" class="absolute gauge"></div>
<div id="leftright" class="absolute gauge"></div>
