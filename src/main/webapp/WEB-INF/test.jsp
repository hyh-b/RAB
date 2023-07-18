<%@page import="java.util.Date"%>
<%@page import="org.springframework.security.core.Authentication"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.example.model.MainTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>
     test RAB
    </title>

   
<c:set var="seq" value="${requestScope.seq}" />
  <!-- jstl 로 lists 받아옴 -->
 <c:forEach var="item" items="${lists}">
   <c:set var="i_seq" value="${item.i_seq}" />
   <c:set var="i_kcal" value="${item.i_kcal}" />
   <c:set var="i_carbohydrate_g" value="${item.i_carbohydrate_g}" />
   <c:set var="i_protein_g" value="${item.i_protein_g}" />
   <c:set var="i_fat_g" value="${item.i_fat_g}" />
   <c:set var="i_sugar_g" value="${item.i_sugar_g}" />
   <c:set var="i_cholesterol_mgl" value="${item.i_cholesterol_mgl}" />
   <c:set var="i_sodium_mg" value="${item.i_sodium_mg}" />
   <c:set var="i_trans_fat_g" value="${item.i_trans_fat_g}" />
   <c:set var="i_day" value="${item.i_day}" />
   <c:set var="i_used_kcal" value="${item.i_used_kcal}" />
   
   <c:set var="m_id" value="${item.m_id}"/>
   <c:set var="m_weight" value="${item.m_weight}"/>
    <c:set var="m_seq" value="${item.m_seq}"/>
   <c:set var="m_gender" value="${item.m_gender}"/>
   <c:set var="m_target_weight" value="${item.m_target_weight}"/>
   <c:set var="totarget" value="${item.m_weight- item.m_target_weight}" />
   <c:set var="m_name" value="${item.m_name}" />       				     
</c:forEach>

<!--  tailwindcss로 그린 아이콘, apexChart -->
  <link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/apexcharts@3.28.3"></script> 

<!-- jQuery, jQuery Dialog, jQuery Calendar, fontAwesome --> 
  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
  <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
  
 <!--  피드백 아이콘 -->
 <style>
	.chatbot-icon {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background-color: #ff0000; 
    position: fixed !important;
    bottom: 20px !important;
    
    right: 33px !important;
    
    z-index: 1000;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
	}
	
	.chatbot-icon .fas {
	    font-size: 30px; 
	    color: #ffffff;  
	}
	.chatbot-dialog {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: #ffffff;
    width: 400px;
    border-radius: 5px;
    box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.2);
    display: none;
	}
	
	.dialog-header {
	    padding: 10px;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    border-bottom: 1px solid #e0e0e0;
	}
	
	.dialog-title {
	    font-weight: bold;
	}
	
	.dialog-close {
	    border: none;
	    background: transparent;
	    font-size: 20px;
	    cursor: pointer;
	    outline: none;
	}
	
	.dialog-body {
	    padding: 10px;
	}
	
	.form-row {
	    margin-bottom: 10px;
	}
	
	.form-row label {
	    display: block;
	    font-weight: bold;
	}
	
	.form-row input,
	.form-row textarea {
	    width: 100%;
	    padding: 5px;
	    border-radius: 5px;
	    border: 1px solid #e0e0e0;
        
	}
	.form-row textarea {
    width: 100%;
    padding: 5px;
    border-radius: 5px;
    border: 1px solid #e0e0e0;
    height: 135px; 
	}
	
	.dialog-footer {
	    padding: 10px;
	    text-align: right;
	}
	
	.dialog-footer button {
	    padding: 5px 10px;
	    border-radius: 5px;
	    background-color: #ff0000;
	    color: #ffffff;
	    border: none;
	    cursor: pointer;
	}
	
 </style>
 
<script>
//----------------------함수-----------------------------

		//반복해서 함수들이 그 자리를 대체하게 하는 함수
		function assignDateChangeListener() {
	
		$("#calendarCtInput").off("change"); 

		$("#calendarCtInput").on("change", function() {
    		//selectedDate = $(this).val();

    		loadDataFromDate();
    
    		PieDataForDate();
    		
    		BarChartForDate();
    		
    		AreaChartForWeek();

		});

		}

		assignDateChangeListener();
	
		//------------날짜에 맞춰서 4elements 표시---------------------------------------

		function loadDataFromDate() {
	
			//var zzinid = $("#zzinid").val();
			var zzinseq = $("#zzinseq").val();
			selectedDate = $("#calendarCtInput").val();
	
			//console.log( " loadDataFromDate() id ->", zzinid );
	
		$.ajax({
			url: "/selected_data",
      		type: "get",
      		dataType: 'json',
      		
      		data: {
         		day: selectedDate,
         		seq: zzinseq
      		},
      
      		success: function (elements) {
    	  
    	  	//console.log("  함수에서 selectedDate -> ", selectedDate);
    	
       //데이터 넘어오는거 검사 섹션
   	   
       		//console.log("m_seq ->", elements.m_seq);
   	   		//console.log(" m_id ->", elements.m_id);
       
   	   		//console.log("i_day ->", elements.i_day);
       		//console.log("i_kcal ->", elements.i_kcal);
       		//console.log("i_used_kcal ->", elements.i_used_kcal);
       		//console.log("m_weight ->", elements.m_weight);
       		//console.log("m_target_weight ->", elements.m_target_weight);

	   		//달력
        	var calendarhtml = '<li> <label for="start"></label> <input type="date" id="calendarCtInput" name="trip-start" value="' + selectedDate + '" min="2023-02-01" max="2023-12-31"> </li>';

        	$('#calendarCt').html(calendarhtml);
        
        	assignDateChangeListener();
       
        	//몸무게 동적처리
			//var toTarget = elements.i_weight - elements.m_target_weight;
			//var toTarget = Math.abs(elements.i_weight - elements.m_target_weight);
			
			//절대값 처리, 소수점 둘째짜리까지 제한
			var toTarget = parseFloat(Math.abs(elements.i_weight - elements.m_target_weight).toFixed(2));

        	var whtml = '';

        	if(elements.i_weight === undefined || elements.m_target_weight === undefined ) {
       	   		whtml = '<span class="text-sm font-medium">달력에서 날짜를 선택해주세요</span>';
       		} else if (elements.i_weight < elements.m_target_weight) {
       	   		whtml = '<span class="text-sm font-medium">목표까지 + ' + toTarget + ' kg</span>';
       		} else if(elements.i_weight > elements.m_target_weight) {
       	   		whtml = '<span class="text-sm font-medium">목표까지 - ' + toTarget + ' kg</span>';
      		} else if (elements.i_weight == elements.m_target_weight) {
       	   		whtml = '<span class="text-sm font-medium">목표달성을 축하드립니다! <a href="board_list.do"><u>당신의 성공을 공유하세요!</u></a></span>';
       	   //console.log(" undefined ? ->? ", elements.m_weight);
       		}
			$('#targetWeight').html(whtml);

        	//main 상자 4개 jQuery
			
        	//
        	let firstElementHtml = '<h4 class="text-title-md font-bold text-black dark:text-white">' + selectedDate + '</h4><span class="text-sm font-medium"></span>';
			$("#firstElement").html(firstElementHtml);

			//
			let secondElementHtml = '<h4 class="text-title-md font-bold text-black dark:text-white">' + (elements.i_kcal || 0) + ' kcal</h4><span class="text-sm font-medium">섭취 칼로리</span>';
			$("#secondElement").html(secondElementHtml);

			//
			let thirdElementHtml = '<h4 class="text-title-md font-bold text-black dark:text-white">' + (elements.i_used_kcal || 0) + 'kcal</h4><span class="text-sm font-medium">소모 칼로리</span>';
			$("#thirdElement").html(thirdElementHtml);
			//
			let fourthElementHtml = '<h4 class="text-title-md font-bold text-black dark:text-white">'+ (elements.i_weight || 0) +' kg</h4>';
			$("#fourthElement").html(fourthElementHtml);
			
      	},
     	  error: function (error) {
         	console.log('에러는 -> ', error);
         	console.log('\n 응답 JSON -> ', error.responseJSON);
         	console.log('\n 응답 본문 -> ', error.responseText);

      	 }
    	
		});
	}
	//---4elements 끝--------------------------------------------
	
//---------------------------차트 함수화 시작------------------------------------------
	
	//---pie 함수--------------------------
		var pieChart;
	
		function PieDataForDate() {
		
			//var zzinid = $("#zzinid").val();
			var zzinseq = $("#zzinseq").val();
			var selectedDate = $("#calendarCtInput").val();
			
			//console.log( " pie 함수에서 zzinid -> ", zzinid); 
			//console.log( " pie 함수에서 selectedDate -> ", selectedDate); 

			$.ajax({
			url: "/pie_chart_data",
			type: "GET",
			data: {
  				day: selectedDate,
  				seq: zzinseq
			},
			success: function(pie) {
				
				//console.log( " pie.영양소들 -> ", pie);
				
			 	var pies = JSON.parse(pie);
			 	
			 	//console.log( " pies.영양소들 -> ", pies);
				
  				var pieData = [pies[0].i_carbohydrate_g, pies[0].i_protein_g, pies[0].i_fat_g
  					
  					];
				
  				//pie가 없으면 새로 만들고 있으면 업데이트 해서 파이가 무한으로 생겨나게 하는 방지 if 문
  				 if (!pieChart) {
  	                
  	                var pieOptions = {
  	                    series: pieData,
  	                    chart: {
  	                        type: "pie",
  	                        height: 350,
  	                    },
  	                  	labels: ['탄수 ' + pies[0].i_carbohydrate_g + 'g' , '단백 ' + pies[0].i_protein_g + 'g', '지방 ' + pies[0].i_fat_g + 'g'],
  	                  dataLabels: {
  	                    enabled: true,
  	                    style: {
  	                        colors: ['#FFA500', '#FF4500', '#008000'], // 각 라벨의 색상을 바꾸려면 여기를 변경하세요
  	                        fontSize: '14px', // 폰트 크기를 바꾸려면 여기를 변경하세요
  	                        fontFamily: 'Helvetica, Arial, sans-serif', // 폰트를 바꾸려면 여기를 변경하세요
  	                    },
  	                	
  	                  },
					  responsive: [{
  	                        breakpoint: 480,
  	                        options: {
  	                            chart: {
  	                                width: 200,
  	                            },
  	                            legend: {
  	                                position: "bottom",
  	                            },
  	                        },
  	                    }],
  	                };
  	                pieChart = new ApexCharts(document.querySelector("#chart"), pieOptions);
  	                pieChart.render();
  	            } else {
  	                
  	                pieChart.updateSeries(pieData);
  	                
  	              	pieChart.updateOptions({
  	                	labels: ['탄수 ' + pies[0].i_carbohydrate_g + 'g', '단백 ' + pies[0].i_protein_g + 'g', '지방 ' + pies[0].i_fat_g + 'g']
  	            	});
  	            }

		},
		
		error: function(e) {
  		console.log("pie에서 에러 ->", e);
		},
	});
			
	}	
	//---pie 함수 끝--------------------------------------------------

////////bar함수 차트 undefined넘어와도 비율 안깨지게 날짜 포메팅 not finished--

		var selectedDate;
		
		function generateDates(selectedDate) {
		  var dates = [];
		  var currentDate = new Date(selectedDate);
		  currentDate.setDate(currentDate.getDate() - 3);
		
		  for (var i = 0; i < 7; i++) {
		    var year = currentDate.getFullYear();
		    var month = currentDate.getMonth() + 1;
		    var date = currentDate.getDate();
		    var formattedDate = `${year}-${month < 10 ? '0' + month : month}-${date < 10 ? '0' + date : date}`;
		    dates.push(formattedDate);
		    currentDate.setDate(currentDate.getDate() + 1);
		  }
		
		  return dates;
		}

	//---bar 함수----------------------------------------------------
	var barChart;

	function BarChartForDate() {
	  var selectedDate = $("#calendarCtInput").val();
	  var zzinseq = $("#zzinseq").val();

	  //console.log("BarChartForDate 함수에서 zzinseq -> ", zzinseq);
	  //console.log("BarChartForDate 함수에서 selectedDate -> ", selectedDate);

	  $.ajax({
	    url: "/bar_chart_data",
	    type: "GET",
	    data: {
	      day: selectedDate,
	      seq: zzinseq
	    },
	    success: function(bar) {
	      var bars = JSON.parse(bar);
	      
	      //console.log(" bars.요소들 -> ", bars);
	      //console.log(" i_breakfast_kcal -> ", bars[0].i_breakfast_kcal);
	      //console.log(" i_lunch -> ", bars[0].i_lunch_kcal);
	      //console.log(" i_dinner -> ", bars[0].i_dinner_kcal);
	      //console.log(" i_day bar차트에서 -> ", bars[0].i_day);

	      var BreakfastKcal = [];
	      var LunchKcal = [];
	      var DinnerKcal = [];
	      var BarChartCategories = [];

	      for (var i = 0; i < bars.length; i++) {
	        var dateParts = bars[i].i_day.split(' ');
	        var barMonth = dateParts[1].replace("월", '');
	        var barDate = dateParts[2].replace("일", '');
	        var barDay = dateParts[3];
	        var BarDate = barMonth + '.' + barDate + ' ' + barDay;

	        BarChartCategories.push(BarDate);
	        BreakfastKcal.push(bars[i].i_breakfast_kcal);
	        LunchKcal.push(bars[i].i_lunch_kcal);
	        DinnerKcal.push(bars[i].i_dinner_kcal);
	      }

	      var barData = [
	        { name: '아침', data: BreakfastKcal },
	        { name: '점심', data: LunchKcal },
	        { name: '저녁', data: DinnerKcal }
	      ];

	      var barOptions = {
	        series: barData,
	        chart: {
	          type: 'bar',
	          height: 350,
	          stacked: true,
	          toolbar: {
	            show: true
	          },
	          zoom: {
	            enabled: true
	          }
	        },
	        responsive: [{
	          breakpoint: 480,
	          options: {
	            legend: {
	              position: 'bottom',
	              offsetX: -10,
	              offsetY: 0
	            }
	          }
	        }],
	        plotOptions: {
	          bar: {
	            horizontal: false,
	            borderRadius: 10,
	            dataLabels: {
	              total: {
	                enabled: true,
	                style: {
	                  fontSize: '13px',
	                  fontWeight: 900
	                }
	              }
	            }
	          }
	        },
	        xaxis: {
	          type: 'text',
	          categories: BarChartCategories
	        },
	        legend: {
	          position: 'top',
	          horizontalAlign: 'center',
	          offsetY: 10,
	          markers: {
	            radius: 12
	          }
	        },
	        fill: {
	          opacity: 1
	        }
	      };

	      if (!barChart) {
	        barChart = new ApexCharts(document.querySelector("#chartstacked"), barOptions);
	        barChart.render();
	      } else {
	        barChart.updateOptions(barOptions);
	        barChart.updateSeries(barData);
	      }
	    },
	    error: function(e) {
	      console.log("BarChartForDate에서 에러 ->", e);
	    },
	  });
	}

	//---bar 함수 끝 -------------------------------------------------
////////	
	//---area 함수----------------------------------------------------
	var areaChart;

	function AreaChartForWeek() {
		
		var selectedDate = $("#calendarCtInput").val();
	    var zzinseq = $("#zzinseq").val();

		 console.log(" AreaChartForDate 함수에서 zzinseq -> ", zzinseq);
		 console.log(" AreaChartForDate 함수에서 selectedDate -> ", selectedDate);

	    $.ajax({
	        url: "/area_chart_data",
	        type: "get",
	        dataType: 'json',
	        data: {
	  	      day: selectedDate,
	  	      seq: zzinseq
	  	    },
	        success: function (areaForWeeks) {
	        	
	        	//console.log(" areaForWeeks => ", areaForWeeks);
	        	
        	    var lastWeekData = areaForWeeks.lastWeekData.map(function(data) { return data.i_used_kcal; });
        	    var thisWeekData = areaForWeeks.thisWeekData.map(function(data) { return data.i_used_kcal; });
	        	
	        	//console.log(" lastWeekData => ", lastWeekData);
	        	//console.log(" thisWeekData => ", thisWeekData);
	        	
	            var areaOptions = {
	                series: [{
	                    name: '저번주',
	                    data: lastWeekData
	                }, {
	                    name: '이번주',
	                    data: thisWeekData
	                }],
	                chart: {
	                    height: 350,
	                    type: 'area'
	                },
	                dataLabels: {
	                    enabled: false
	                },
	                stroke: {
	                    curve: 'smooth'
	                },
	                xaxis: {
	                    type: 'category',
	                    categories: ['일', '월', '화', '수', '목', '금', '토'],
	                    labels: {
	                        show: true,
	                        formatter: function (value, timestamp, opts) {
	                            return value;
	                        }
	                    }
	                },
	                tooltip: {
	                    x: {
	                        format: 'dd'
	                    },
	                },
	            };
	            if(areaChart) {
	                areaChart.updateOptions(areaOptions);
	            } else {
	                areaChart = new ApexCharts(document.querySelector("#barchart"), areaOptions);
	                areaChart.render();
	            }
	        },
	        error: function (error) {
	            console.log('에러는 -> ', error);
	            console.log('\n 응답 JSON -> ', error.responseJSON);
	            console.log('\n 응답 본문 -> ', error.responseText);
	        }
	    });
	}
	
	
	//---area 함수 끝 -------------------------------------------------
////////

	//---line 함수----------------------------------------------------
	
	var lineChart;

	function LineChartForMonth() {

		var selectedYear = $("#yearSelectForLineChart").val();
		var zzinseq = $("#zzinseq").val();
		
		//console.log( " 선택된 년도 확인 -> ", selectedYear);
		
	    $.ajax({
	        url: '/line_chart_data',
	        method: 'GET',
	        dataType: 'json',
	        data: {
	  	      year: selectedYear,
	  	      seq: zzinseq
	  	    },
	        success: function(line) {
	            //console.log("line ->", line);
	            
				event.preventDefault(); // 스크롤 위로 튕기는 거 잡아줘야 되는데.
	            
	            var weights = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	
	            for(var i=0; i<line.length; i++) {
	                var monthIndex = parseInt(line[i].month) - 1;  
	                weights[monthIndex] = line[i].avg_weight; 
	            

	                //console.log(" line[i].month => ", line[i].month);
	               //console.log(" line[i].avg_weight => ", line[i].avg_weight);
	            }

	            //console.log(" line weights => ", weights);
	
	            // 차트 옵션
	            var lineOptions = {
	                series: [{
	                    name: "월별 몸무게",
	                    data: weights
	                }],
	                chart: {
	                    height: 350,
	                    type: 'line',
	                    zoom: {
	                        enabled: false
	                    }
	                },
	                dataLabels: {
	                    enabled: false
	                },
	                stroke: {
	                    curve: 'straight'
	                },
	                title: {
	                    text: '단위 : kg',
	                    align: 'left'
	                },
	                grid: {
	                    row: {
	                        colors: ['#000000', 'transparent'],
	                        opacity: 0.5
	                    },
	                },
	                xaxis: {
	                    categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월','11월', '12월' ],
	                }
	            };
	            
	            // 차트를 새로 그립니다.
	            if(lineChart) {
	                lineChart.destroy();
	            }
	            lineChart = new ApexCharts(document.querySelector("#chartline"), lineOptions);
	            lineChart.render();
	        }
	    });
	}
	
	
	//---line 함수 끝 -------------------------------------------------
////////

	//---------------------------차트 함수화 끝------------------------------------------

	
//---------------------------- 페이지 요소가 전부 불려오고 난 후 적용될 스크립트 ( 동적 )----------------------------

 window.onload = function() {
		
//--달력 라벨 밸류 디폴트는 현재로컬타임 기준으로 세팅됨----------------------------------------------
		var currentDate = new Date();

		var day = ("0" + currentDate.getDate()).slice(-2);
		var month = ("0" + (currentDate.getMonth() + 1)).slice(-2);
		var year = currentDate.getFullYear();

		var formattedDate = year + "-" + month + "-" + day;

		var calendarhtml = '<li> <label for="start"></label> <input type="date" id="calendarCtInput" name="trip-start" value="' + formattedDate + '" min="2023-01-01" max="2050-12-31"></li>';
    
		$('#calendarCt').html(calendarhtml);
	
		console.log( " formattedDate -> " , formattedDate );

		var selectedDate = formattedDate;
		/////////////////////////////

//---  몸무게 업데이트 다이얼로그----------------------
	
	// 몸무게 다이얼로그 안 달력
	$(function() {
  		$("#dateInput").datepicker({
	    dateFormat: "yy-mm-dd",
	    minDate: new Date(2023, 0, 1),
	    maxDate: new Date(2050, 11, 31),
	    defaultDate: new Date(),
	    onSelect: function(dateText, inst) {
	      $(this).val(dateText);
	    }
	  });
	});
		
    // 오늘의 몸무게 다이얼로그 팝업
	$('#weightTodayDropdown').click(function(e) {
  		e.preventDefault();
  	$('#weightForToday').dialog('open');
	});

	// 목표 몸무게 재설정 다이얼로그 팝업
	$('#targetWeightUpdateDropdown').click(function(e) {
  		e.preventDefault();
  	$('#targetWeightUpdate').dialog('open');
	});

	//  몸무게 다이얼로그 설정
	$('#weightForToday').dialog({
	  autoOpen: false,
	  modal: true,
	  buttons: {
	    '계속입력': function() {
	        var weight = $(this).find('#weightInput').val();
		      var date = $(this).find('#dateInput').val();
	    	  var zzinseq = $("#zzinseq").val();
	    	  
	    	  //console.log( " 몸무게 업데이트/날짜 -> ", zzinseq);
	    	  //console.log( " 몸무게 업데이트/몸무게 -> ", weight); 
	    	  //console.log( " 몸무게 업데이트/날짜 -> ", date);
	    	  
		      
		      if(weight === '' || isNaN(weight)) { 
		        alert('숫자를 입력해주세요');
		      } else if (!/^(\d*\.?\d{0,2})$/.test(weight)) {
	              alert('특수문자 대신에 숫자를 입력해주세요 (소수점은 두자리 까지만!)');
	          } else if ( date === ''){
	              alert('날짜를 선택해주세요');
	          }
		      else {
		    	  $.ajax({
		              url: "/weight_update",
		              method: "POST",
		              data: {
	            	  	seq: zzinseq, 
		                i_weight: weight,
		                dialogDate : date
		              },
		              success: function() {
		                alert(' ' + weight + ' kg ' + date + ' 에 등록되었습니다.');
		                loadDataFromDate();
		              },
		              error: function(jqXHR, textStatus, errorThrown) {
	            	    //console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
	            	    //console.log('Throw Error: ' + errorThrown); // 예외 정보
	            	    //console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
		                
	            	    alert('업데이트에 실패했습니다');
		              }
		            });

		            //$(this).dialog('close');
		          }
	    	
	     },
	    '입력': function() {
	      var weight = $(this).find('#weightInput').val();
	      var date = $(this).find('#dateInput').val();
    	  var zzinseq = $("#zzinseq").val();
    	  
    	  //console.log( " 몸무게 업데이트/날짜 -> ", zzinseq);
    	  //console.log( " 몸무게 업데이트/몸무게 -> ", weight); 
    	  //console.log( " 몸무게 업데이트/날짜 -> ", date);
    	  
	      
	      if(weight === '' || isNaN(weight)) { 
	        alert('숫자를 입력해주세요');
	      } else if (!/^(\d*\.?\d{0,2})$/.test(weight)) {
              alert('특수문자 대신에 숫자를 입력해주세요 (소수점은 두자리 까지만!)');
          } else if ( date === ''){
              alert('날짜를 선택해주세요');
          }
	      else {
	    	  $.ajax({
	              url: "/weight_update",
	              method: "POST",
	              data: {
            	  	seq: zzinseq, 
	                i_weight: weight,
	                dialogDate : date
	              },
	              success: function() {
	                alert(' ' + weight + ' kg ' + date + ' 에 등록되었습니다.');
	                loadDataFromDate();
	              },
	              error: function(jqXHR, textStatus, errorThrown) {
            	    //console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
            	    //console.log('Throw Error: ' + errorThrown); // 예외 정보
            	    //console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
	                
            	    alert('업데이트에 실패했습니다');
	              }
	            });

	            $(this).dialog('close');
	          }
	        },
	    '취소': function() {
	      $(this).dialog('close');
	    }
	  },
	  close: function() {
	    $(this).find('#weightInput').val('');
	  }
	});

	// 목표 몸무게 다이얼로그 설정
	$('#targetWeightUpdate').dialog({
	  autoOpen: false,
	  modal: true,
	  buttons: {
	    '업데이트': function() {
	      var tweight = $(this).find('#TweightInput').val();
	      var zzinseq = $("#zzinseq").val();

	 	  //console.log( " 목표 몸무게 업데이트/날짜 -> ", zzinseq);
    	  //console.log( " 목표 몸무게 업데이트/몸무게 -> ", tweight); 
	      
	      if(tweight === '' || isNaN(tweight)) { 
	          alert('숫자를 입력해주세요');
	      } else if (!/^(\d*\.?\d{0,2})$/.test(tweight)) {
              alert('특수문자 대신에 숫자를 입력해주세요 (소수점은 두자리 까지만!)');
	      } else {
	    	  $.ajax({
	              url: "/weight_update",
	              method: "POST",
	              data: {
            	  	seq: zzinseq, 
            	  	target_weight : tweight
	              },
	              success: function() {
	                alert('목표 몸무게가' + tweight + ' kg로 설정되었습니다!');
	                loadDataFromDate();
	              },
	              error: function(jqXHR, textStatus, errorThrown) {
            	    console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
            	    console.log('Throw Error: ' + errorThrown); // 예외 정보
            	    console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
	                
            	    alert('업데이트에 실패했습니다');
	              }
	            });

	            $(this).dialog('close');
	      	 }
	     },
	    '취소': function() {
	      $(this).dialog('close');
	    }
	  },
	  close: function() {
	    $(this).find('#TweightInput').val('');
	  }
	});
		
	//---함수등록 칸  ------------------ 바뀌는 날짜에 대해서 모든 데이터가 비동기적으로 처리됨-----------------------------------------
    $("#calendarCtInput").on("change", function() {
        	
        	selectedDate = $(this).val();
        	
        	console.log("달력 value 확인 ->", selectedDate);
        	
            loadDataFromDate();
         
          	PieDataForDate();
          	
            AreaChartForWeek();

            	
        });
	
	//년도별로 월평균 보여주기.
    $("#yearSelectForLineChart").on("change", function() {
    	
    	event.preventDefault();
    	  
    	console.log(" select 년도 확인 ->",  $(this).val());
    	
      	LineChartForMonth();
        	
    });

//////
  	};//window.onload끝 
//////

////////////페이지 로드시 기본값 오늘데이터 뿌려주기///////////////////
	var selectedDate;
	
	$(document).ready(function() {
			//--오늘 날짜로 선택된 값을 바로 전달해서 ----------------------------------------------
			var currentDate = new Date();
	
			var day = ("0" + currentDate.getDate()).slice(-2);
			var month = ("0" + (currentDate.getMonth() + 1)).slice(-2);
			var year = currentDate.getFullYear();
	
			var formattedDate = year + "-" + month + "-" + day;
	
			var calendarhtml = '<li> <label for="start"></label> <input type="date" id="calendarCtInput" name="trip-start" value="' + formattedDate + '" min="2023-01-01" max="2050-12-31"></li>';
	    
			$('#calendarCt').html(calendarhtml);
		
			console.log( " formattedDate -> " , formattedDate );
	
			selectedDate = formattedDate; 
			
			///
			var ldate = new Date();
			var lcurrentYear = ldate.getFullYear();
			
			// Create an option for the previous year, the current year, and the next year.
			for(var lyear = lcurrentYear - 2; lyear <= lcurrentYear + 2; lyear++) {
			    var option = document.createElement("option");
			    option.value = lyear;
			    option.text = lyear + " 년";
			
			    // If this is the current year, make it the default selection.
			    if(lyear == lcurrentYear) {
			        option.selected = true;
			    }
			
			    document.getElementById("yearSelectForLineChart").appendChild(option);
			}
			
			///
	
			loadDataFromDate();
			PieDataForDate();
			BarChartForDate();
			AreaChartForWeek();
			LineChartForMonth();
			
		// 피드백 다이얼로그
			document.querySelector('.chatbot-icon').addEventListener('click', function() {
			    document.querySelector('.chatbot-dialog').style.display = 'block';
			    resetForm();
			});

			document.querySelector('.dialog-close').addEventListener('click', function() {
			    document.querySelector('.chatbot-dialog').style.display = 'none';
			    resetForm();
			});
			
			
			document.querySelector('#submit-btn').addEventListener('click', function() {
			    // Get input values
			    
			    var zzinseq = $("#zzinseq").val();
			    var f_name = $("#zzinname").val();
			    var f_id = $("#zzinid").val();
			    var f_mail = $("#zzinmail").val();
			    
			    var f_subject = document.querySelector('#f_subject').value;
			    var f_content = document.querySelector('#f_content').value;
			    
			    console.log(" feedback 데이터들 -> ", zzinseq, f_name, f_id, f_mail, f_subject, f_content  );
			    // feedback ajax요청
			    if (f_subject.trim() === "" || f_content.trim() === "") {
			        alert("제목과 내용을 입력해주세요.");
			      } else {
			       
			        $.ajax({
			          url: "/feedback_ok",
			          method: "POST",
			          data: {
		            	  	seq: zzinseq, 
		            	  	f_id : f_id,
		            	  	f_name : f_name,
		            	  	f_mail : f_mail,
		            	  	f_subject : f_subject,
		            	  	f_content : f_content
			              },
			          success: function () {
			            alert("소중한 피드백 감사합니다!");
			            document.querySelector(".chatbot-dialog").style.display = "none";
			            resetForm();
			          },
			          error: function (jqXHR, textStatus, errorThrown) {
			            console.log("HTTP Status: " + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
			            console.log("Throw Error: " + errorThrown); // 예외 정보
			            console.log("jqXHR Object: " + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
			            alert("업데이트에 실패했습니다");
			          },
			        });
			      }
			    });

			  
			    document.querySelector("#f_name").value = $("#zzinname").val();
			    document.querySelector("#f_id").value = $("#zzinid").val();
			    document.querySelector("#f_mail").value = $("#zzinmail").val();
			    
			    //제목, 콘텐츠 입력칸 초기화
			    function resetForm() {
			        document.querySelector("#f_subject").value = "";
			        document.querySelector("#f_content").value = "";
			    }
	    	/// 피드백 다이얼로그 끝

	});
</script>



</head>

  <body
    x-data="{ page: 'analytics', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
    x-init="
         darkMode = JSON.parse(localStorage.getItem('darkMode'));
         $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
    :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}"
  >
  
  <input type="hidden" id="zzinid" value="${zzinid}" />
  <input type="hidden" id="zzinseq" value="${zzinseq}" />
  <input type="hidden" id="zzinname" value="${zzinname}" />
  <input type="hidden" id="zzinmail" value="${zzinmail}" />
    <!-- ===== Preloader Start ===== -->
    <div
  x-show="loaded"
  x-init="window.addEventListener('DOMContentLoaded', () => {setTimeout(() => loaded = false, 500)})"
  class="fixed left-0 top-0 z-999999 flex h-screen w-screen items-center justify-center bg-white"
>
  <div
    class="h-16 w-16 animate-spin rounded-full border-4 border-solid border-primary border-t-transparent"
  ></div>
</div>
	
	
	

    <!-- ===== Preloader End ===== -->

    <!-- ===== Page Wrapper Start ===== -->
    <div class="flex h-screen overflow-hidden">
    
 <!-- ===== Sidebar Start ===== -->
      <aside
  :class="sidebarToggle ? 'translate-x-0' : '-translate-x-full'"
  class="absolute left-0 top-0 z-9999 flex h-screen w-72.5 flex-col overflow-y-hidden bg-black duration-300 ease-linear dark:bg-boxdark lg:static lg:translate-x-0"
  @click.outside="sidebarToggle = false"
>
  <!-- SIDEBAR HEADER -->
  <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5">
    <a href="/">
    
   <!--  사이트 로고  -->

     <img src="src/images/logo/logo2.jpg" width="100%" height="100%" />
    </a>
  
   <!--
     <img src="src/images/logo/rocatNOb.png" width="50%" height="50%" />
    </a>
 -->

    <button
      class="block lg:hidden"
      @click.stop="sidebarToggle = !sidebarToggle"
    >
      <svg
        class="fill-current"
        width="20"
        height="18"
        viewBox="0 0 20 18"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M19 8.175H2.98748L9.36248 1.6875C9.69998 1.35 9.69998 0.825 9.36248 0.4875C9.02498 0.15 8.49998 0.15 8.16248 0.4875L0.399976 8.3625C0.0624756 8.7 0.0624756 9.225 0.399976 9.5625L8.16248 17.4375C8.31248 17.5875 8.53748 17.7 8.76248 17.7C8.98748 17.7 9.17498 17.625 9.36248 17.475C9.69998 17.1375 9.69998 16.6125 9.36248 16.275L3.02498 9.8625H19C19.45 9.8625 19.825 9.4875 19.825 9.0375C19.825 8.55 19.45 8.175 19 8.175Z"
          fill=""
        />
      </svg>
    </button>
  </div>
  <!-- SIDEBAR HEADER -->

  <div
    class="no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear"
  >
    <!-- Sidebar Menu -->
    <nav
      class="mt-5 py-4 px-4 lg:mt-9 lg:px-6"
      x-data="{selected: 'Dashboard'}"
      x-init="
        selected = JSON.parse(localStorage.getItem('selected'));
        $watch('selected', value => localStorage.setItem('selected', JSON.stringify(value)))"
    >
    </nav>
      <!-- Menu Group -->
      <div>
        <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2">메뉴</h3>
        flag : ${flag}

        <ul class="mb-6 flex flex-col gap-1.5">
          <!-- Menu Item Dashboard -->

          <!-- Menu Item Calendar -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="calendar.do"
              @click="selected = (selected === 'Calendar' ? '':'Calendar')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Calendar') && (page === 'calendar') }"
            >

            <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>

              공지사항
            </a>
          </li>
          <!-- Menu Item Calendar -->

          <!-- Menu Item Profile -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"

              href="board_list.do"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >
             <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="게시판.png"
      			width="24"
      			height="24"
   			/>
             	게시판
            </a>
          </li>
          <!-- Menu Item Profile -->

              <!-- Menu Item Profile2 -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="food.do"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >

               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="식단.png"
      			width="24"
      			height="24"
   			/>
             	식단
            </a>
          </li>
          <!-- Menu Item Profile2 -->
       

          <!-- Menu Item Forms -->

          <!-- Menu Item Tables -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="exercise.do"

              @click="selected = (selected === 'Tables' ? '':'Tables')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Tables') && (page === 'Tables') }"
            >
            <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="운동.png"
      			width="24"
      			height="24"
   			/>

              운동
            </a>
            
     
          </li>
          
          <!--  마이페이지 li -->
             
           <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"

              href="profile.do"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >
             <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="마이페이지.png"
      			width="24"
      			height="24"
   			/>
             	마이페이지
            </a>
          </li>

          
          <!--  -->
          
          <!-- Menu Item Tables -->
		  <br/><br/>
          <!-- Menu Item Settings -->
 
           
        <li>
			<a
    			class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
    			href="/klogout.do"
    			@click="selected = (selected === 'Settings' ? '':'Settings')"
    			:class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Settings') && (page === 'settings') }"
    			:class="page === 'settings' && 'bg-graydark'"
 			>
   			<img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="로그아웃"
      			width="24"
      			height="24"
   			/>
    			로그아웃
  			</a>
		</li>
          
          <!-- Menu Item Settings -->
        </ul>
      </div>

      <!-- Support Group -->
 
          <!-- Menu Item Messages -->
        
          <!-- Menu Item Chart -->
         
      
          <!-- Menu Item Chart -->

          <!-- Menu Item Ui Elements -->
        
          <!-- Menu Item Ui Elements -->

          <!-- Menu Item Auth Pages -->
          
            <!-- Dropdown Menu End -->
   
          <!-- Menu Item Auth Pages -->
       
    <!-- Sidebar Menu -->

    <!-- Promo Box -->

    <!-- Promo Box -->
  </div>
</aside>

      <!-- ===== Sidebar End ===== -->

      <!-- ===== Content Area Start ===== -->
      <div
        class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden"
      >
        <!-- ===== Header Start ===== -->
    <header
  class="sticky top-0 z-999 flex w-full bg-white drop-shadow-1 dark:bg-boxdark dark:drop-shadow-none"
>
  <div
    class="flex flex-grow items-center justify-between py-4 px-4 shadow-2 md:px-6 2xl:px-11"
  >
    <div class="flex items-center gap-2 sm:gap-4 lg:hidden">
      <!-- Hamburger Toggle BTN -->
      <button
        class="z-99999 block rounded-sm border border-stroke bg-white p-1.5 shadow-sm dark:border-strokedark dark:bg-boxdark lg:hidden"
        @click.stop="sidebarToggle = !sidebarToggle"
      >
        <span class="relative block h-5.5 w-5.5 cursor-pointer">
          <span class="du-block absolute right-0 h-full w-full">
            <span
              class="relative top-0 left-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-[0] duration-200 ease-in-out dark:bg-white"
              :class="{ '!w-full delay-300': !sidebarToggle }"
            ></span>
            <span
              class="relative top-0 left-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-150 duration-200 ease-in-out dark:bg-white"
              :class="{ '!w-full delay-400': !sidebarToggle }"
            ></span>
            <span
              class="relative top-0 left-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-200 duration-200 ease-in-out dark:bg-white"
              :class="{ '!w-full delay-500': !sidebarToggle }"
            ></span>
          </span>
          <span class="du-block absolute right-0 h-full w-full rotate-45">
            <span
              class="absolute left-2.5 top-0 block h-full w-0.5 rounded-sm bg-black delay-300 duration-200 ease-in-out dark:bg-white"
              :class="{ 'h-0 delay-[0]': !sidebarToggle }"
            ></span>
            <span
              class="delay-400 absolute left-0 top-2.5 block h-0.5 w-full rounded-sm bg-black duration-200 ease-in-out dark:bg-white"
              :class="{ 'h-0 dealy-200': !sidebarToggle }"
            ></span>
          </span>
        </span>
      </button>
        <!-- Hamburger Toggle BTN -->
      <a class="block flex-shrink-0 lg:hidden" href="/">
        <img src="src/images/logo/" alt="홈 로고 추가해야되요" />
      </a>
    </div>
    
    <!--  검색 창 -->
    <div class="hidden sm:block">
    
    </div>
    <!--  검색 창  끝-->
    
 <!-- 오늘의 몸무게 업데이트 다이얼로그 -->
<div id="weightForToday" title="몸무게 입력">
  <form>
    <label for="weightInput">몸무게 입력:</label>
    <input type="text" id="weightInput" class="text ui-widget-content">
    <br>
    <label for="dateInput"><u>날짜 선택</u></label>
    <input type="text" id="dateInput" readonly>
    <br>
  </form>
</div>
    <!-- 오늘의 몸무게 업데이트 끝 -->

 <!-- 목표 몸무게 업데이트 다이얼로그 -->
 <div id="targetWeightUpdate" title="목표 몸무게 재설정">
  <form>
    <label for="TeightInput">목표 몸무게 설정:</label>
    <input type="text" id="TweightInput" class="text ui-widget-content">
    <br>
  </form>
</div>
    <!-- 목표 몸무게 업데이트 끝 -->
    


    <div class="flex items-center gap-3 2xsm:gap-7">
      <ul class="flex items-center gap-2 2xsm:gap-4">
        <li>
          <!-- Dark Mode Toggler -->
          <label
            :class="darkMode ? 'bg-primary' : 'bg-stroke'"
            class="relative m-0 block h-7.5 w-14 rounded-full"
          >
            <input
              type="checkbox"
              :value="darkMode"
              @change="darkMode = !darkMode"
              class="absolute top-0 z-50 m-0 h-full w-full cursor-pointer opacity-0"
            />
            <span
              :class="darkMode && '!right-[3px] !translate-x-full'"
              class="absolute top-1/2 left-[3px] flex h-6 w-6 -translate-y-1/2 translate-x-0 items-center justify-center rounded-full bg-white shadow-switcher duration-75 ease-linear"
            >
              <span class="dark:hidden">
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 16 16"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M7.99992 12.6666C10.5772 12.6666 12.6666 10.5772 12.6666 7.99992C12.6666 5.42259 10.5772 3.33325 7.99992 3.33325C5.42259 3.33325 3.33325 5.42259 3.33325 7.99992C3.33325 10.5772 5.42259 12.6666 7.99992 12.6666Z"
                    fill="#969AA1"
                  />
                  <path
                    fill="#969AA1"
                  />
                </svg>
              </span>
              <span class="hidden dark:inline-block">
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 16 16"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M14.3533 10.62C14.2466 10.44 13.9466 10.16 13.1999 10.2933C12.7866 10.3667 12.3666 10.4 11.9466 10.38C10.3933 10.3133 8.98659 9.6 8.00659 8.5C7.13993 7.53333 6.60659 6.27333 6.59993 4.91333C6.59993 4.15333 6.74659 3.42 7.04659 2.72666C7.33993 2.05333 7.13326 1.7 6.98659 1.55333C6.83326 1.4 6.47326 1.18666 5.76659 1.48C3.03993 2.62666 1.35326 5.36 1.55326 8.28666C1.75326 11.04 3.68659 13.3933 6.24659 14.28C6.85993 14.4933 7.50659 14.62 8.17326 14.6467C8.27993 14.6533 8.38659 14.66 8.49326 14.66C10.7266 14.66 12.8199 13.6067 14.1399 11.8133C14.5866 11.1933 14.4666 10.8 14.3533 10.62Z"
                    fill="#969AA1"
                  />
                </svg>
              </span>
            </span>
          </label>
        </li>
      </ul>

      <!-- User Area -->
      <div
        class="relative"
        x-data="{ dropdownOpen: false }"
        @click.outside="dropdownOpen = false"
      >
        <a
          class="flex items-center gap-4"
          href="#"
          @click.prevent="dropdownOpen = ! dropdownOpen"
        >
          <span class="hidden text-right lg:block">
            <span class="block text-sm font-medium text-black dark:text-white"

              >${m_name}</span
            >
            <span class="block text-xs font-medium">${m_gender}</span>
          </span>

          <span class="h-12 w-12 rounded-full">
          <!--  프로필 사진 업로드 파일 경로 설정 => C:/java/RAB-workspace/RABver/RABver/src/main/webapp/src/images/user -->
            <img src="https://rabfile.s3.ap-northeast-2.amazonaws.com/${profilename}" alt="User" />

          </span>

          <svg
            :class="dropdownOpen && 'rotate-180'"
            class="hidden fill-current sm:block"
            width="12"
            height="8"
            viewBox="0 0 12 8"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              fill-rule="evenodd"
              clip-rule="evenodd"
              d="M0.410765 0.910734C0.736202 0.585297 1.26384 0.585297 1.58928 0.910734L6.00002 5.32148L10.4108 0.910734C10.7362 0.585297 11.2638 0.585297 11.5893 0.910734C11.9147 1.23617 11.9147 1.76381 11.5893 2.08924L6.58928 7.08924C6.26384 7.41468 5.7362 7.41468 5.41077 7.08924L0.410765 2.08924C0.0853277 1.76381 0.0853277 1.23617 0.410765 0.910734Z"
              fill=""
            />
          </svg>
        </a>

        <!-- Dropdown Start -->
        <div
          x-show="dropdownOpen"
          class="absolute right-0 mt-4 flex w-62.5 flex-col rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark"
        >
          <ul
            class="flex flex-col gap-5 border-b border-stroke px-6 py-7.5 dark:border-strokedark"
          >
            <li>
              <a
                href="profile.do"
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
              >
               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>
                내 정보
              </a>
            </li>
            
             <li>
             <div id="weightTodayDropdown">
              <a
                href=""
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
              >
               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>
                몸무게 입력
              </a>
              </div>
            </li>
            
             <li>
             <div id="targetWeightUpdateDropdown">
              <a
                href=""
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
              >
               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>
                목표 몸무게 재설정
              </a>
              </div>
            </li>
            
          </ul>
          
          
          
          
          <button
            class="flex items-center gap-3.5 py-4 px-6 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
          >
            <svg
              class="fill-current"
              width="22"
              height="22"
              viewBox="0 0 22 22"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M15.5375 0.618744H11.6531C10.7594 0.618744 10.0031 1.37499 10.0031 2.26874V4.64062C10.0031 5.05312 10.3469 5.39687 10.7594 5.39687C11.1719 5.39687 11.55 5.05312 11.55 4.64062V2.23437C11.55 2.16562 11.5844 2.13124 11.6531 2.13124H15.5375C16.3625 2.13124 17.0156 2.78437 17.0156 3.60937V18.3562C17.0156 19.1812 16.3625 19.8344 15.5375 19.8344H11.6531C11.5844 19.8344 11.55 19.8 11.55 19.7312V17.3594C11.55 16.9469 11.2062 16.6031 10.7594 16.6031C10.3125 16.6031 10.0031 16.9469 10.0031 17.3594V19.7312C10.0031 20.625 10.7594 21.3812 11.6531 21.3812H15.5375C17.2219 21.3812 18.5625 20.0062 18.5625 18.3562V3.64374C18.5625 1.95937 17.1875 0.618744 15.5375 0.618744Z"
                fill=""
              />
              <path
                d="M6.05001 11.7563H12.2031C12.6156 11.7563 12.9594 11.4125 12.9594 11C12.9594 10.5875 12.6156 10.2438 12.2031 10.2438H6.08439L8.21564 8.07813C8.52501 7.76875 8.52501 7.2875 8.21564 6.97812C7.90626 6.66875 7.42501 6.66875 7.11564 6.97812L3.67814 10.4844C3.36876 10.7938 3.36876 11.275 3.67814 11.5844L7.11564 15.0906C7.25314 15.2281 7.45939 15.3312 7.66564 15.3312C7.87189 15.3312 8.04376 15.2625 8.21564 15.125C8.52501 14.8156 8.52501 14.3344 8.21564 14.025L6.05001 11.7563Z"
                fill=""
              />
            </svg>
            <a href="/klogout.do">로그아웃</a>
          </button>
        </div>
        <!-- Dropdown End -->
      </div>
      <!-- User Area -->
    </div>
  </div>
</header>

        <!-- ===== Header End ===== -->

        <!-- ===== Main Content Start ===== -->
        <main>
          <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
            <div
              class="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-4 2xl:gap-7.5"
            >
              <!-- Card Item Start -->
              <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                	<!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/calendar.png" width="100%" height="100%" />
					</svg>

                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>

                <div class="mt-4 flex items-end justify-between">
                  <div id="firstElement">
          		        
               
                   
     		    
                  </div>
                </div>
                
               <!--  달력날짜 컨트롤러  -->
                  <div id="calendarCt">
               
              	  </div>
              </div>
              <!-- Card Item End -->

              <!-- Card Item Start -->
              <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                  <!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/foodicon.png" width="100%" height="100%" />
					</svg>

                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>

                <div class="mt-4 flex items-end justify-between">
                
                  <div id="secondElement">
            

                  </div>

                </div>
              </div>
              <!-- Card Item End -->

              <!-- Card Item Start -->
              <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                 	<!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/exercise.png" width="100%" height="100%" />
					</svg>

                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>

                <div class="mt-4 flex items-end justify-between">
                
                  <div id="thirdElement">
            
                  </div>

                </div>
              </div>
              <!-- Card Item End -->

              <!-- Card Item Start -->
             <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                  <!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/scale.png" width="100%" height="100%" />
					</svg>
					
                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>
                
                <div class="mt-4 flex items-end justify-between">

                
<div class="mt-4 flex flex-col">
    <div id="fourthElement">
        <!-- fourthElement에 대한 기존 HTML 코드 -->
    </div>
    <br>
    <div id="targetWeight">
        <!-- 동적으로 처리되는 HTML이 삽입될 위치 -->
    </div>
</div>

             
                   
                </div>
              </div>
              <!-- Card Item End -->
            </div>

            <!-- ====== Chart Ones Start -->
            <div class="mt-4 grid grid-cols-12 gap-4 md:mt-6 md:gap-6 2xl:mt-7.5 2xl:gap-7.5">
            
			<!--  스택 그래프 -->
			<div class="col-span-12 rounded-sm border border-stroke bg-white px-4 pt-6 pb-4 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-6 xl:col-span-8">
			    <div class="col-span-12 grid grid-cols-2 gap-4">
			        <div>
			            <h4 class="text-xl font-bold text-black dark:text-white">
			                이번주 섭취 칼로리
			            </h4>
			            <div id="chartstacked" class="mx-auto flex justify-center mt-2"></div>
			        </div>
			    </div>
			</div>
			
			<!-- ===== 파이 그래프 시작 ====== -->	
			<div class="col-span-12 rounded-sm border border-stroke bg-white p-10 shadow-default dark:border-strokedark dark:bg-boxdark xl:col-span-4">
			    <div class="mb-6 justify-center">
			        <div style="width: 100%; height: 100%; padding-bottom: 5px;"> <!-- 여기서 padding-bottom을 추가하여 그래프를 아래로 이동 -->
			            <h4 class="mb-10 text-xl font-bold text-black dark:text-white">
			                일일 섭취 영양 성분
			            </h4>
			            <div id="chart" class="mx-auto flex justify-center mt-2"></div>
			        </div>
			    </div>
			</div>





		   <!-- ===== 파이 그래프 끝 ====== -->		
</div>

              <!-- ====== Chart Two End -->

              <!-- ====== Chart Three Start -->
              <br/>
              <div class="col-span-12 rounded-sm border border-stroke bg-white px-5 pt-7.5 pb-5 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:col-span-5">
               <div class="mb-3 justify-between gap-4 sm:flex">
			    <div>
			      <h4 class="text-xl font-bold text-black dark:text-white">
			        저번주와 이번주 소모 칼로리 비교
			      </h4>
			    </div>
    
			  </div>
			  <div class="mb-2">
			    <div id="barchart" class="flex justify-center"></div>
			  </div>
			</div>

              <!-- ====== Chart Three End -->
			<br/>
              <!-- ====== Map One Start -->
              <div class="col-span-12 rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark xl:col-span-7">
				  <h4 class="mb-2 text-xl font-bold text-black dark:text-white">
				    내 몸무게 변화
				  </h4>
				  <select id="yearSelectForLineChart" class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">

				  </select>
				  
<!-- 				    <div id="chartline" class="mx-auto flex justify-center"></div> -->
				    <div id="chartline" class="mx-auto flex justify-center"></div>
			</div>
              <!-- ====== Map One End -->

              <!-- ====== Table One Start -->

              <!-- ====== Chat Card End -->
            </div>
          </div>
        </main>
        <!-- ===== Main Content End ===== -->
      </div>
      <!-- ===== Content Area End ===== -->
    </div>
    <!-- ===== Page Wrapper End ===== -->
  <script defer src="bundle.js"></script>
 
     
<div class="chatbot-icon">
    <i class="fas fa-question"></i>
</div>

<div class="chatbot-dialog">
    <div id="c_dialog">
        <div class="dialog-header">
            <span class="dialog-title">피드백 작성</span>
            <button class="dialog-close">&times;</button>
        </div>
        <div class="dialog-body">
            <form>
                <div class="form-row">
                    <label for="name">이름</label>
                    <input type="text" id="f_name" readonly>
                </div>
                <div class="form-row">
                    <label for="id">아이디</label>
                    <input type="text" id="f_id" readonly>
                </div>
                <div class="form-row">
                    <label for="mail">이메일</label>
                    <input type="email" id="f_mail" readonly>
                </div>
                <div class="form-row">
                    <label for="subject">제목</label>
                    <input type="text" id="f_subject">
                </div>
                <div class="form-row">
                    <label for="content">내용</label>
                    <textarea id="f_content" placeholder="캡쳐본을 붙혀넣으실 수 있습니다!                          (Window + Shift + L로 캡쳐 후 Ctrl + V)"></textarea>
                </div>
            </form>
        </div>
        <div class="dialog-footer">
            <button id="submit-btn">전송</button>
        </div>
    </div>
</div>

</body>
    
</html>