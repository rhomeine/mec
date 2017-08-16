<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<html>
  <head>
    <base href="<%=basePath%>"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <!--页面标题-->
    <title>Video Player</title>
    <link href="https://cdn.bootcss.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" rel="stylesheet">    
    <link href="https://cdn.bootcss.com/flat-ui/2.3.0/css/flat-ui.min.css" rel="stylesheet">
  </head>
  
  <body>
	<div class="container-fluid">
    <div class="row">
      <div class="col-md-6">
          <h1>MEC服务器</h1>
          <video id="player" src="daguojueqi.mp4" controls="controls"  width="480" height="320"></video>
          <p id="info">nothing to show</p>
          <p id="time">nothing to show</p>
      </div>
      <div class="col-md-6">
          <h1>远程服务器</h1>
          <video id="player2" src="http://www.wimobile.net/video/4.mp4"  controls="controls" width="480" height="320"></video>
          <p id="info2">nothing to show</p>
          <p id="time2">nothing to show</p>

      </div>
    </div>
          <div class="row">
          <div class="col-xs-6 col-md-6"><button type="button" class="btn btn-success" onclick="startVideo()">播放</button></div>
          <div class="col-xs-6 col-md-6"><button type="button" class="btn btn-info" onclick="pauseVideo()">暂停</button></div>
     </div>
  </div>
    

  <script type="text/javascript">
    var startTime = new Date().getTime();
		var pre_buffered = 0;
		var cur_buffered = 0;
    var sizeOfVideo = 202866533;//byte
		window.onload = function getLoadedProgress(){
			var myPlayer = document.getElementById('player');
			myPlayer.addEventListener('progress',function(){
        var duration = myPlayer.duration;
        if(duration>0){
          for (var i = 0; i < myPlayer.buffered.length; i++) {
            if (myPlayer.buffered.start(myPlayer.buffered.length - 1 - i) < myPlayer.currentTime) {
              var progress = (myPlayer.buffered.end(myPlayer.buffered.length - 1 - i) / duration) * 100;
              var curTime = new Date().getTime();
              pre_buffered = cur_buffered;
              cur_buffered = progress;
              rate = (cur_buffered - pre_buffered)*sizeOfVideo*10 /((curTime-startTime)*1024*1024);
              // console.log((cur_buffered - pre_buffered)+" dur:"+(curTime-startTime)+"rate: "+rate);
              startTime = curTime;
              document.getElementById("info").innerHTML = "Buffered progress: " + progress.toFixed(2) + "%" +"\nDownloading rate: "+rate.toFixed(2)+" MB/s";
              break;
            }
          }
        }
      });

      myPlayer.addEventListener('timeupdate', function() {
        var duration =  myPlayer.duration;
        if (duration > 0) {
          var time = (myPlayer.currentTime / duration)*100;
          document.getElementById('time').innerHTML = "Playing progress: " + time.toFixed(2) + "%";
        }
      });

      var startTime2 = new Date().getTime();
		  var pre_buffered2 = 0;
		  var cur_buffered2 = 0;
      var myPlayer2 = document.getElementById('player2');
			myPlayer2.addEventListener('progress',function(){
        var duration = myPlayer2.duration;
        if(duration>0){
          for (var i = 0; i < myPlayer2.buffered.length; i++) {
            if (myPlayer2.buffered.start(myPlayer2.buffered.length - 1 - i) < myPlayer2.currentTime) {
              var progress = (myPlayer2.buffered.end(myPlayer2.buffered.length - 1 - i) / duration) * 100;
              var curTime = new Date().getTime();
              pre_buffered2 = cur_buffered2;
              cur_buffered2 = progress;
              rate = (cur_buffered2 - pre_buffered2)*sizeOfVideo*10 /((curTime-startTime2)*1024*1024);
              // console.log((cur_buffered2 - pre_buffered2)+" dur:"+(curTime-startTime2)+"rate: "+rate);
              startTime2 = curTime;
              document.getElementById("info2").innerHTML = "Buffered progress: " + progress.toFixed(2) + "%" +"\nDownloading rate: "+rate.toFixed(2)+" MB/s";
              break;
            }
          }
        }
      });

      myPlayer2.addEventListener('timeupdate', function() {
        var duration =  myPlayer2.duration;
        if (duration > 0) {
          var time = (myPlayer2.currentTime / duration)*100;
          document.getElementById('time2').innerHTML = "Playing progress: " + time.toFixed(2) + "%";
        }
      });

		}
    
    function startVideo(){
      document.getElementById("player").play();
      document.getElementById("player2").play();
      alert("启动视频");
    }

    function pauseVideo(){
      document.getElementById("player").pause();
      document.getElementById("player2").pause();
      alert("暂停播放");
    }
	</script>
  </body>
  <!--引入jquery脚本-->
<script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/tether/1.4.0/js/tether.min.js"></script>
<!--引入bootstrap脚本-->
<script src="https://cdn.bootcss.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js"></script>
<!-- 引入flatUI -->
<script src="https://cdn.bootcss.com/flat-ui/2.3.0/js/flat-ui.js"></script>
</html>