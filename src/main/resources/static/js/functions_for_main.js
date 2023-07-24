//----------------------함수-----------------------------

		//반복해서 함수들이 그 자리를 대체하게 하는 함수
		function assignDateChangeListener() {
	
		$("#calendarCtInput").off("change"); 

		$("#calendarCtInput").on("change", function() {
    		//selectedDate = $(this).val();

    		loadDataFromDate();
    		
    		MacroPieChart();
    		
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
   	   
       		//console.log(" 메인칸 zzinseq ->", zzinseq);
   	   		//console.log(" m_id ->", elements.m_id);
       
   	   		//console.log("i_day ->", elements.i_day);
       		//console.log(" 메인칸 i_kcal ->", elements.i_kcal);
       		//console.log(" 메인칸 i_used_kcal ->", elements.i_used_kcal);
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
       	   		whtml = '<span class="text-sm font-medium">목표달성을 축하드립니다! <a href="board.do"><u>당신의 성공을 공유하세요!</u></a></span>';
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
	

		function MacroPieChart() {
		    var zzinseq = $("#zzinseq").val();
		    var selectedDate = $("#calendarCtInput").val();

		    $.ajax({
		        url: "/pie_chart_data",
		        type: "GET",
		        data: {
		            day: selectedDate,
		            seq: zzinseq
		        },
		        success: function(pie)  {
		            var pies = JSON.parse(pie);
		            var pieData = [pies[0].i_carbohydrate_g, pies[0].i_protein_g, pies[0].i_fat_g];

		            var pieOptions = {
		                series: pieData,
		                chart: {
		                    type: "pie",
		                    height: 350,
		                },
		                labels: ['탄수', '단백', '지방'],
		                dataLabels: {
		                    enabled: true,
		                    offset: 20,
		                    formatter: function(val, opts) {
		                        // opts.seriesIndex는 현재 데이터 포인트의 인덱스입니다.
		                        var labels = ['탄수', '단백', '지방'];  // 라벨 배열
		                        return labels[opts.seriesIndex] + ': ' + val.toFixed(2) + 'g';  // 라벨 포맷
		                    },
		                    style: {
		                        colors: ['#FFA500', '#FF4500', '#008000'],
		                        fontSize: '14px',
		                        fontFamily: 'Helvetica, Arial, sans-serif',
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

		            if (pieChart) {
		                pieChart.destroy();
		            }

		            pieChart = new ApexCharts(document.querySelector("#chart"), pieOptions);
		            pieChart.render();
		        },
		        error: function(e) {
		            console.log("pie에서 에러 ->", e);
		        },
		    });
		}

		function SugarPieChart() {
		    var zzinseq = $("#zzinseq").val();
		    var selectedDate = $("#calendarCtInput").val();

		    $.ajax({
		        url: "/pie_chart_data",
		        type: "GET",
		        data: {
		            day: selectedDate,
		            seq: zzinseq
		        },
		        success: function(pie)  {
		            var pies = JSON.parse(pie);
		            var pieData = [pies[0].i_cholesterol_mgl/1000, pies[0].i_sodium_mg/1000, pies[0].i_sugar_g];

		            var pieOptions = {
		                series: pieData,
		                chart: {
		                    type: "pie",
		                    height: 350,
		                },
		                labels: ['콜레스테롤', '나트륨', '설탕'],
		                dataLabels: {
		                    enabled: true,
		                    offset: 20,
		                    formatter: function(val, opts) {
		                        // opts.seriesIndex는 현재 데이터 포인트의 인덱스입니다.
		                        var labels = ['콜레스테롤', '나트륨', '설탕'];  // 라벨 배열
		                        return labels[opts.seriesIndex] + ': ' + val.toFixed(2) + 'g';  // 라벨 포맷
		                    },
		                    style: {
		                        colors: ['#FFA500', '#FF4500', '#008000'],
		                        fontSize: '14px',
		                        fontFamily: 'Helvetica, Arial, sans-serif',
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


		            if (pieChart) {
		                pieChart.destroy();
		            }

		            pieChart = new ApexCharts(document.querySelector("#chart"), pieOptions);
		            pieChart.render();
		        },
		        error: function(e) {
		            console.log("pie에서 에러 ->", e);
		        },
		    });
		}
	//---콜나당 끝----------------
	


	//---pie 함수 끝--------------------------------------------------

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
	            
				event.preventDefault();
	            
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
	                },
	                tooltip: {
	                    y: {
	                        formatter: function(val) {
	                            return val.toFixed(2); // 데이터 포인트에 대한 소수점 둘째 자리까지 표시합니다.
	                        }
	                    }
	                },
	                yaxis: {
	                    labels: {
	                        formatter: function (val) {
	                            return val.toFixed(0);  // 소수점 둘째 자리까지 표시합니다.
	                        }
	                    }
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