
//---------------------------- 페이지 요소가 전부 불려오고 난 후 적용될 스크립트----------------------------
var selected;

 window.onload = function() {
		
	    document.getElementById('pieChartSelect').addEventListener('change', function(e) {
	        if (this.value === 'tandanji') {
	            MacroPieChart();
	        } else if (this.value === 'colnadang') {
	            SugarPieChart();
	        }
	    });
		
//--달력 라벨 밸류 디폴트는 현재로컬타임 기준으로 세팅됨----------------------------------------------

		var currentDate = new Date();

		var day = ("0" + currentDate.getDate()).slice(-2);
		var month = ("0" + (currentDate.getMonth() + 1)).slice(-2);
		var year = currentDate.getFullYear();

		var formattedDate = year + "-" + month + "-" + day;

		var calendarhtml = '<li> <label for="start"></label> <input type="date" id="calendarCtInput" name="trip-start" value="' + formattedDate + '" min="2023-01-01" max="2050-12-31"></li>';
    
		$('#calendarCt').html(calendarhtml);
	
		//console.log( " formattedDate -> " , formattedDate );

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
	  modal: false,
	  buttons: {
	    '계속입력': function() {
	        var weight = $(this).find('#weightInput').val();
		      var date = $(this).find('#dateInput').val();
	    	  var zzinseq = $("#zzinseq").val();
	    	  
	    	  //console.log( " 몸무게 업데이트/날짜 -> ", zzinseq);
	    	  //console.log( " 몸무게 업데이트/몸무게 -> ", weight); 
	    	  //console.log( " 몸무게 업데이트/날짜 -> ", date);
	    	  
		      
	      if(weight === '' || isNaN(weight)) {  
             swal({
                  title: "다시 입력해주세요!",
                  text: "숫자를 입력해주세요",
                  icon: "warning",
                  button: "확인",            
              });
		      } else if (!/^(\d*\.?\d{0,2})$/.test(weight)) {
	          	 swal({
                  title: "다시 입력해주세요!",
                  text: "특수문자 대신에 숫자를 입력해주세요 \n( 소수점은 두자리 까지만! )",
                  icon: "warning",
                  button: "확인",            
              });
	          } else if ( date === ''){
	              swal({
                  title: "다시 입력해주세요!",
                  text: "날짜를 선택해주세요",
                  icon: "warning",
                  button: "확인",            
              });
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
                
                 swal({
                  title: "성공!",
                  text: ' ' + weight + ' kg ' + date + ' 에 등록되었습니다.',
                  icon: "success",
                  button: "확인",
        		 });
	                loadDataFromDate();
	              },
	              error: function(jqXHR, textStatus, errorThrown) {
            	    //console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
            	    //console.log('Throw Error: ' + errorThrown); // 예외 정보
            	    //console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
	                
            	   
            	    swal({
              			title: "실패!",
              			text: "업데이트에 실패했습니다",
             			icon: "error",
              			button: "확인",            
          			});
            	    
	              }
            });

            	//$(this).dialog('close');
            	//계속 입력이라서 비활성화 시킴
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
	        swal({
                  title: "다시 입력해주세요!",
                  text: "숫자를 입력해주세요",
                  icon: "warning",
                  button: "확인",            
              });
	      } else if (!/^(\d*\.?\d{0,2})$/.test(weight)) {
             swal({
                  title: "다시 입력해주세요!",
                  text: "특수문자 대신에 숫자를 입력해주세요 \n( 소수점은 두자리 까지만! )",
                  icon: "warning",
                  button: "확인",            
              });
          } else if ( date === ''){
              swal({
                  title: "다시 입력해주세요!",
                  text: "날짜를 선택해주세요",
                  icon: "warning",
                  button: "확인",            
              });
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
	             
                 	swal({
	                  title: "성공!",
	                  text: ' ' + weight + ' kg ' + date + ' 에 등록되었습니다.',
	                  icon: "success",
	                  button: "확인",
            		 });

	                loadDataFromDate();
	                LineChartForMonth()
	              },
	              error: function(jqXHR, textStatus, errorThrown) {
            	    //console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
            	    //console.log('Throw Error: ' + errorThrown); // 예외 정보
            	    //console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
	                
        	       swal({
              			title: "실패!",
              			text: "업데이트에 실패했습니다",
             			icon: "error",
              			button: "확인",            
          			});
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
	           swal({
                  title: "다시 입력해주세요!",
                  text: "숫자를 입력해주세요",
                  icon: "warning",
                  button: "확인",            
              });
	      } else if (!/^(\d*\.?\d{0,2})$/.test(tweight)) {
               swal({
                  title: "다시 입력해주세요!",
                  text: "특수문자 대신에 숫자를 입력해주세요 \n( 소수점은 두자리 까지만! )",
                  icon: "warning",
                  button: "확인",            
              });
	      } else {
	    	  $.ajax({
	              url: "/weight_update",
	              method: "POST",
	              data: {
            	  	seq: zzinseq, 
            	  	target_weight : tweight
	              },
	              success: function() {
	                swal({
	                  title: "성공!",
	                  text: '목표 몸무게가' + tweight + ' kg로 설정되었습니다!',
	                  icon: "success",
	                  button: "확인",
            		 });

	                loadDataFromDate();
	              },
	              error: function(jqXHR, textStatus, errorThrown) {
            	    console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
            	    console.log('Throw Error: ' + errorThrown); // 예외 정보
            	    console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
	                
            	     swal({
              			title: "실패!",
              			text: "업데이트에 실패했습니다",
             			icon: "error",
              			button: "확인",            
          			});
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
        	
        	//console.log("달력 value 확인 ->", selectedDate);
        	
            loadDataFromDate();
         
          	//PieDataForDate();
          	
          	MacroPieChart();
          	
            AreaChartForWeek();

            	
        });
	
	//년도별로 월평균 보여주기.
    $("#yearSelectForLineChart").on("change", function() {
    	
    	event.preventDefault();
    	  
    	//console.log(" select 년도 확인 ->",  $(this).val());
    	
      	LineChartForMonth();
        	
    });

	
	loadDataFromDate();
	MacroPieChart();
	BarChartForDate();
	AreaChartForWeek();
	LineChartForMonth();

//////
  	};//window.onload끝 
//////
