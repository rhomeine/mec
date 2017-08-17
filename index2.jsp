<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<html>
  <head>
  	<script src="https://cdn.bootcss.com/Chart.js/2.6.0/Chart.min.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <!--页面标题-->
    <title>Video Player</title>
    <link href="https://cdn.bootcss.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" rel="stylesheet">    
    <link href="https://cdn.bootcss.com/flat-ui/2.3.0/css/flat-ui.min.css" rel="stylesheet">
  </head>
  
  <body>
	<div class="container-fluid">
	<h2  style="text-align:center;color:#1ABC9C;">高清视频优化加速比较</h2>
    <div class="row">
      <div class="col-md-6">
          <h6 style="text-align:center" style="margin:0px;">MEC视频服务</h6>
          <video id="player" src="daguojueqi.mp4" controls="controls"  width="480" height="300"></video>
          <div>
          <p id="info">nothing to show</p>
          </div>

      </div>
      <div class="col-md-6">
          <h6 style="text-align:center" style="margin:0px;">传统视频下载</h6>
          <video id="player2" src="http://www.wimobile.net/video/4.mp4"  controls="controls" width="480" height="300"></video>
          <div>
          <p id="info2">nothing to show</p>
          </div>
      </div>
    </div>
     <div class="row">
      <div class="col-md-3">
		    <canvas id="myChart" height="200"></canvas>
      </div>
      <div class="col-md-3">
		    <canvas id="myChart1" height="200"></canvas>
      </div>
      <div class="col-md-3">
		    <canvas id="myChart2" height="200"></canvas>
      </div>
      <div class="col-md-3" style="padding-top:20px;">
		  <button type="button" class="btn btn-success" onclick="startVideo()">播放</button>
      <button type="button" class="btn btn-info" onclick="pauseVideo()">暂停</button>
      </div>
     </div>
     <!-- <div class="row">
        <canvas id="myChart3" height="200"></canvas>
     </div> -->
  </div>
    

  <script type="text/javascript">

    var buf_progress1 = 0,
        buf_progress2 = 0,
        play_progress1 = 0,
        play_progress2 = 0,
        download_rate1 = 0,
        download_rate2 = 0;
    var startTime = new Date().getTime();
		var pre_buffered = 0;
		var cur_buffered = 0;
    var sizeOfVideo = 202866533;//byte
    var data = {
      type: 'bar',
      data: {
          labels: ["MEC", "远程"],
          datasets: [{
              label: "缓存进度 %",
              data: [0, 0],
              backgroundColor: [
                  'rgba(255, 99, 132, 0.3)',
                  'rgba(54, 162, 235, 0.3)',
              ],
              borderColor: [
                  'rgba(255,99,132,1)',
                  'rgba(54, 162, 235, 1)',
              ],
              borderWidth: 1,
          }]
      },
      options: {
          scales: {
              xAxes: [{
                  ticks: {
                      beginAtZero:true
                  },
                  barPercentage: 0.4
              }],
              yAxes: [{
                  ticks: {
                      beginAtZero:true,
                      max:100
                  }
              }]
          },
          title: {
            display: false,
            text: '缓存进度 %'
        },
        animation:{
          duration:0
        }
      }
  };

    var data1 = {
    type: 'bar',
    data: {
        labels: ["MEC", "远程"],
        datasets: [{
          label: "播放进度 %",
            data: [0, 0],
            backgroundColor: [
                'rgba(255, 99, 132, 0.3)',
                'rgba(54, 162, 235, 0.3)',
            ],
            borderColor: [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
            ],
            borderWidth: 1,
        }]
    },
    options: {
        scales: {
            xAxes: [{
                ticks: {
                    beginAtZero:true
                },
                barPercentage: 0.4
            }],
            yAxes: [{
                ticks: {
                    beginAtZero:true,
                    max:100
                }
            }]
        },
          title: {
            display: false,
            text: '播放进度 %'
        },
        animation:{
          duration:0
        }
    }
  };

  var data2 = {
    type: 'bar',
    data: {
        labels: ["MEC", "远程"],
        datasets: [{
          label: "下载速率MB/s",
            data: [0, 0],
            backgroundColor: [
                'rgba(255, 99, 132, 0.3)',
                'rgba(54, 162, 235, 0.3)',
            ],
            borderColor: [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
            ],
            borderWidth: 1,
        }]
    },
    options: {
        scales: {
            xAxes: [{
                barPercentage: 0.4
            }],
            yAxes: [{
                ticks: {
                    beginAtZero:true,
                    max:10
                }
            }]
        },
          title: {
            display: false,
            text: '下载速率MB/s'
        },
        animation:{
          duration:0
        }
    }
  };
  
  var data3 = {
		    type: 'line',
		    data: {
		        labels: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],
		        datasets: [{
		          label: "MEC",
		            data: [0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                fillColor : "rgba(220,220,220,0.5)",
                strokeColor : "rgba(220,220,220,1)",
                pointColor : "rgba(220,220,220,1)",
                pointStrokeColor : "#fff",
		            borderWidth: 1,
		        },
            {
            	label: "远程",
		            data: [0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                fillColor : "rgba(151,187,205,0.5)",
                strokeColor : "rgba(151,187,205,1)",
                pointColor : "rgba(151,187,205,1)",
                pointStrokeColor : "#fff",
		            borderWidth: 1,
		        },
            ]
		    },
		    options: {
		        scales: {
		            xAxes: [{
		                barPercentage: 0.4
		            }],
		            yAxes: [{
		                ticks: {
		                    beginAtZero:true,
		                    max:10
		                }
		            }]
		        },
		          title: {
		            display: false,
		            text: '下载速率MB/s'
		        },
		        animation:{
		          duration:0
		        }
		    }
		  };
  console.log("create charts");
  var myChart = new Chart(document.getElementById("myChart"), data);
  var myChart1 = new Chart(document.getElementById("myChart1"), data1);
  var myChart2 = new Chart(document.getElementById("myChart2"), data2);
  // var myChart3 = new Chart(document.getElementById("myChart3"), data3);
  
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
              data.data.datasets[0].data[0] = progress.toFixed(2);
              data2.data.datasets[0].data[0] = rate.toFixed(2);
              download_rate1 = rate.toFixed(2);
              buf_progress1 = progress.toFixed(2);
              // updateChart(0,0,progress.toFixed(2));
              // updateChart(2,0,rate.toFixed(2));
              break;
            }
          }

        }
      });

      myPlayer.addEventListener('timeupdate', function() {
        var duration =  myPlayer.duration;
        if (duration > 0) {
          var time = (myPlayer.currentTime / duration)*100;
          data1.data.datasets[0].data[0] = time.toFixed(2);
          play_progress1 = time.toFixed(2);
          // updateChart(1,0,time.toFixed(2));
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
              data.data.datasets[0].data[1] = progress.toFixed(2);
              data2.data.datasets[0].data[1] = rate.toFixed(2);
              download_rate2 = rate.toFixed(2);
              buf_progress2 = progress.toFixed(2);
              // updateChart(0,1,progress.toFixed(2));
              // updateChart(2,1,rate.toFixed(2));
              break;
            }
          }

        }
      });

      myPlayer2.addEventListener('timeupdate', function() {
        var duration =  myPlayer2.duration;
        if (duration > 0) {
          var time = (myPlayer2.currentTime / duration)*100;
          data1.data.datasets[0].data[1] = time.toFixed(2);
          play_progress1 = time.toFixed(2);
          // updateChart(1,1,time.toFixed(2));
        }
      });

		};
    
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

    function updateChart(chart, col , value){
      switch(chart){
        case 0:myChart.data.datasets[0].data[col] = value;myChart.update();break;
        case 1:myChart1.data.datasets[0].data[col] = value;myChart1.update();break;
        case 2:myChart2.data.datasets[0].data[col] = value;myChart2.update();break;
        default: break;
      }
      
    }

    setInterval(function(){
      // myChart.data.datasets[0].data[0] = buf_progress1;
      // myChart.data.datasets[0].data[1] = buf_progress2;
      // myChart1.data.datasets[0].data[0] = play_progress1;
      // myChart1.data.datasets[0].data[1] = play_progress2;
      // myChart2.data.datasets[0].data[0] = download_rate1;
      // myChart2.data.datasets[0].data[1] = download_rate2;
      // data3.data.datasets[0].data.pop();
      // data3.data.labels.forEach(function(val,index,arr){

      // });
      document.getElementById("info").innerHTML = "<span style=\"font-weight:bold;\">缓存进度: </span>" + buf_progress1 + "% &nbsp;&nbsp;&nbsp;" +" <span style=\"font-weight:bold;\">播放进度: </span>" + play_progress1 + "% &nbsp;&nbsp;&nbsp;" + " <span style=\"font-weight:bold;\">下载速率: </span>"+ download_rate1 +" MB/s";
      document.getElementById("info2").innerHTML = "<span style=\"font-weight:bold;\">缓存进度: </span>" + buf_progress2 + "% &nbsp;&nbsp;&nbsp;" +" <span style=\"font-weight:bold;\">播放进度: </span>" + play_progress2 + "% &nbsp;&nbsp;&nbsp;" + " <span style=\"font-weight:bold;\">下载速率: </span>"+ download_rate2 +" MB/s";
      myChart.update();
      myChart1.update();
      myChart2.update();
    },1500);
	</script>
	<script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://cdn.bootcss.com/tether/1.4.0/js/tether.min.js"></script>
	<!--引入bootstrap脚本-->
	<script src="https://cdn.bootcss.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js"></script>
	<!-- 引入flatUI -->
	<script src="https://cdn.bootcss.com/flat-ui/2.3.0/js/flat-ui.js"></script>

  </body>
  <!--引入jquery脚本-->
</html>