	var selectedDate;
	
	$(document).ready(function() {

			///차트함수들
	
			loadDataFromDate();
			MacroPieChart();
			BarChartForDate();
			AreaChartForWeek();
			LineChartForMonth();


	//--lineChart 년도 파라미터 formatting----------------------------------------------
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
			//--lineChart 년도 파라미터 formatting 끝 ----------------------------------------------

	});