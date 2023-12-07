// 이미지 슬라이드 출력
	function imgSlide(){
		
		$.ajax({
			url: '/imgSlide', 
			type: 'GET',
			success: function(response) {
				
				let slideHtml = "";
				let bucketUrl = "https://rabfile.s3.ap-northeast-2.amazonaws.com/";
				for (var i = 0; i < response.length; i++) {
					var fileName = response[i].album_name;
					var albumDay = response[i].album_day;
					slideHtml +=
						'<div class="swiper-slide">'+
						'<img src="'+bucketUrl+fileName+'">'+
						'<div class="slideText">'+albumDay+'</div>'+
						'</div>'
				}
				$('#imgSlide').html(slideHtml);
					new Swiper('.swiper-container', {
						
						slidesPerView : 3, // 동시에 보여줄 슬라이드 갯수
						spaceBetween : 30, // 슬라이드간 간격
						slidesPerGroup : 3, // 그룹으로 묶을 수, slidesPerView 와 같은 값을 지정하는게 좋음
					
						// 그룹수가 맞지 않을 경우 빈칸으로 메우기
						// 3개가 나와야 되는데 1개만 있다면 2개는 빈칸으로 채워서 3개를 만듬
						loopFillGroupWithBlank : true,
					
						loop : false, // 무한 반복 x
					
						pagination : { // 페이징
							el : '.swiper-pagination',
							clickable : true, // 페이징을 클릭하면 해당 영역으로 이동, 필요시 지정해 줘야 기능 작동
						},
						navigation : { // 네비게이션
							nextEl : '.swiper-button-next', // 다음 버튼 클래스명
							prevEl : '.swiper-button-prev', // 이번 버튼 클래스명
						},
					});
			},
			  error: function(xhr, status, error) {
			    // 요청이 실패한 경우에 대한 처리 작성
			    console.error('요청 실패. 상태 코드:', xhr.status);
			}
		});
	} 
	
	//   사진 전체보기 다이어로그 창 설정
	$('#viewBtn').click(function() {
    	$('#photoDialog').css('display', 'block');
	});
	
	$('#closeDialogBtn').click(function() {
	    $('#photoDialog').css('display', 'none');
	});
		
	let currentPage = 1;
	let imagesPerPage = 9;
	let selectedImage = null;
	let selectedImageValue = null;
	
	// 사진 전체보기 이미지 출력
	function displayImages(){
		$.ajax({
			url: '/imgSlide', 
			type: 'GET',
			success: function(response) {
				images = response;
	            let html = '';
	            let bucketUrl = 'https://rabfile.s3.ap-northeast-2.amazonaws.com/';

	            let start = (currentPage - 1) * imagesPerPage;
	            let end = start + imagesPerPage;
	            let imagesToDisplay = images.slice(start, end);

	            for (let i = 0; i < imagesToDisplay.length; i++) {
	                if (i % 3 === 0) {
	                    html += '<div style="display:flex">';
	                }
	                html += '<img src="' + bucketUrl + imagesToDisplay[i].album_name + '" value="' + imagesToDisplay[i].a_seq + '" onclick="selectImage(this)" style="width: 100%; height: 100%; margin-bottom: 20px;">';
	                if ((i + 1) % 3 === 0 || i + 1 === imagesToDisplay.length) {
	                    html += '</div>';
	                }
	            }
				$('#photoContainer').html(html);
			},
			  error: function(xhr, status, error) {
			    console.error('요청 실패. 상태 코드:', xhr.status);
			}
		});
	} 

	// 이미지 선택 기능
	function selectImage(imageElement) {
		if (selectedImage) {
	    	selectedImage.style.border = 'none'; 
	    }
	        imageElement.style.border = '2px solid red'; 
	        selectedImage = imageElement;
	        selectedImageValue = imageElement.getAttribute('value');
	    }
		
	// 이미지 삭제
    function deleteImage() {
        if (!selectedImageValue) {
            //alert('삭제할 이미지를 선택해 주세요');
            swal({
                title: "주의!",
                text: "삭제할 이미지를 선택해 주세요",
                icon: "warning",
                button: "확인",
           });
	        return;
	    }
	        
	    $.ajax({
	    	url: '/exDelete',
	        method: 'POST',
	        data: {
	            aSeq: selectedImageValue
	        },
		    success: function(response) {
		    	
		    	if(response == "삭제 성공"){
		            //alert('이미지가 삭제되었습니다');
		            swal({
		                  title: "성공!",
		                  text: "이미지가 삭제되었습니다",
		                  icon: "success",
		                  button: "확인",
		             });

		            imgSlide();
		            displayImages();
		    	}
	        },
	        error: function(xhr, status, error) {
	            //alert('삭제에 실패했습니다');
	        	swal({
	                  title: "실패!",
	                  text: "삭제에 실패했습니다",
	                  icon: "error",
	                  button: "확인",
	             });

	        },
	        complete: function() {
	            // 실행 후 이미지 선택 해제
	            selectedImage.style.border = 'none';
	            selectedImage = null;
	            selectedImageValue = null;
	        }
	    });
	}
		
    $('#deleteBtn').click(deleteImage);
    
    // 다음 페이지
    function handleNextPage() {
        let totalImages = images.length;
        let totalPages = Math.ceil(totalImages / imagesPerPage);

        if (currentPage < totalPages) {
            currentPage++;
            displayImages();
        }
    }
	    
	// 이전 페이지
	function handlePreviousPage() {
		if (currentPage > 1) {
	        currentPage--;
	        displayImages();
		}
	}

	$('#previousPageBtn').click(handlePreviousPage);
	$('#nextPageBtn').click(handleNextPage);

	/*---------------운동 다이어로그 시작--------- */
	
	function adjustBrightness() {
    var img = document.getElementById('kcalImg');
    if (darkMode) {
      img.style.filter = 'brightness(50%)';
    } else {
      img.style.filter = 'brightness(100%)';
    }
  }
	
	// 운동칸에 추가한 운동 정보 출력하는 함수
	function fetchExercises(date) {
		$.ajax({
	        url: '/viewExercise',
	        type: 'GET',
	        data: { selectedDate: date },
	        success: function(data) {
	            let exerciseHtml = '<div class="exercise-item">';
	            data.forEach(function(exercise, index) {
	            	if (exercise.ex_name) {
	                    exerciseHtml += 
	                    // 각 행마다 인덱스 설정하여 구분
	                    '<div class="exercise-info" style="display: flex;" data-index="'+index+'">' +
	                    	'<button class="dbtn" style="flex: 0.1;"><img src="src/images/logo/deleteBtn.png" width=10px height=10px /></button>'+
	                    	'<div style="flex: 0.15;"></div>'+
	                        '<div class="ex_name" style="flex: 2.6;">'+exercise.ex_name+'</div>'+
	                        '<input class="ex_time dark:bg-form-input" style="flex: 0.3;" value='+exercise.ex_time+' type="number" placeholder="Enter time">'+
	                        '<div style="flex: 0.7;"></div>'+
	                        '<div class="ex_used_kcal" style="flex: 0.3;">'+exercise.ex_used_kcal+'</div>'+
	                    '</div>';
	            	}
	            });
	            exerciseHtml += '</div>';
	            $('#resultExercise1').html(exerciseHtml);
	            
	            let customExerciseHtml = '<div class="customExercise-item">';
		        data.forEach(function(exercise, index) {
		        	if (exercise.ex_name2) {
			            customExerciseHtml += 
		            	// 각 행마다 인덱스 설정하여 구분
		            	'<div class="customExercise-info" style="display: flex;" data-index="'+index+'">' +
		            		'<button class="dbtn" style="flex: 0.1;"><img src="src/images/logo/deleteBtn.png" width=10px height=10px /></button>'+
		            		'<div style="flex: 0.15;"></div>'+
			                '<div style="flex: 2.15;" class="ex_name">'+exercise.ex_name2+'</div>'+
			                '<input "flex: 0.3;" class="ex_time dark:bg-boxdark" type="number" readonly value="' + exercise.ex_time2 + '">'+
			                '<div style="flex: 0.6;"></div>'+
			                '<div "flex: 0.3;" class="ex_used_kcal">'+exercise.ex_used_kcal2+'</div>'+
			                '<div style="flex: 0.15;"></div>'+
			            '</div>';
		        	}
		        });
		        customExerciseHtml += '</div>';
		        $('#resultExercise2').html(customExerciseHtml);
		        calculateTotalTimeAndCalories();
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.error('Fetch error:', errorThrown);
	            console.error('Server response:', jqXHR.responseText);
	        }
	    });
	}
	
	// 다이어로그 내 추가, 취소 버튼 클릭시
	$( function() {
		$( "#dialogContainer1" ).dialog({
			autoOpen: false,
			buttons: {
				"추가": function() {
					if ($('.select-checkbox:checked').length == 0) {
		                //alert('추가할 운동을 선택해주세요');
		                 swal({
			                  title: "주의!",
			                  text: "추가할 운동을 선택해주세요",
			                  icon: "warning",
			                  button: "확인",
			             });

		                return false;
		            }
					let exercises = [];
					let selectedDate = $('#datepicker').val();
					// 체크박스에 체크된 데이터들 서버로 넘김
					$("input.select-checkbox[type='checkbox']:checked").each(function() {
						let exerciseName = $(this).val();
						
						exercises.push(exerciseName);
					});
					$.ajax({
						url: '/exerciseAdd',  
						type: 'POST',
						data: JSON.stringify({ exercise: exercises, date: selectedDate }),
						contentType: "application/json",
						success: function(data) {
							//alert("운동등록에 성공했습니다. 운동 시간을 입력 한 뒤 칼로리 계산버튼을 눌러주세요.")
							swal({
				                  title: "성공!",
				                  text: "운동등록에 성공했습니다. 운동 시간을 입력 한 뒤 칼로리 계산버튼을 눌러주세요.",
				                  icon: "success",
				                  button: "확인",
				             });

							// db의 당일 운동 데이터 출력
							fetchExercises(selectedDate);
							
						},
						error: function(jqXHR, textStatus, errorThrown) {
							// 오류 처리
							//alert('운동등록에 실패했습니다'+ jqXHR.responseText)
							swal({
				                  title: "실패!",
				                  text: "운동등록에 실패했습니다",
				                  icon: "error",
				                  button: "확인",
				             });

							console.error('Server response:', jqXHR.responseText);
						}
        			});
					
					$( this ).dialog( "close" );
					$('#exerciseName1').val('');
		            $('#exerciseDiv1').empty()
				},
				"취소": function() {
					$( this ).dialog( "close" );
				}
			}
		});

		$( "#btn1" ).on( "click", function() {
			$( "#dialogContainer1" ).dialog( "open" );
		});
	});
	

	/* ㅡㅡㅡㅡ사용자 설정 운동 다이어로그 시작 ㅡㅡㅡㅡㅡ*/
	
	$( function() {
	    var dialog, form,
	 
	    dialog = $( "#dialog-form" ).dialog({
	        autoOpen: false,
	        height: 400,
	        width: 350,
	        modal: true,
	        buttons: {
	        	"추가": function() {
	                var name = $('#name').val();
	                var time = $('#time').val();
	                var calorie = $('#calorie').val();
	                if (name === '' ||time === '' ||calorie === '') {
	    		        //alert('추가할 운동 정보를 모두 입력해주세요');
	    		        swal({
	    	                  title: "주의!",
	    	                  text: "추가할 운동 정보를 모두 입력해주세요",
	    	                  icon: "warning",
	    	                  button: "확인",
	    	             });
	    		        return;
	    		    }
	                let selectedDate = $('#datepicker').val();
	                $.ajax({
	                    url: '/addCustomExercise',  
	                    type: 'POST',
	                    data: JSON.stringify({
	                        'ex_name': name,
	                        'ex_time': time,
	                        'ex_used_kcal': calorie,
	                        'selectedDate' : selectedDate
	                    }),
	                    contentType: "application/json; charset=utf-8", 
	                    dataType: "json", 
	                    success: function(response) {
	                    	//alert('운동등록에 성공했습니다');
	                    	 swal({
	                             title: "성공!",
	                             text: "운동등록에 성공했습니다",
	                             icon: "success",
	                             button: "확인",
	                        });

		                	fetchExercises(selectedDate)
	                    },
	                    error: function(jqXHR, textStatus, errorThrown) {
	                        //alert('운동 추가 실패: ' + errorThrown);
	                        swal({
	                            title: "실패!",
	                            text: "운동 추가 실패",
	                            icon: "error",
	                            button: "확인",
	                       });

	                        console.error('Server response:', jqXHR.responseText);
	                    }
	                });
	                dialog.dialog( "close" );
	            },
	            취소: function() {
	                dialog.dialog( "close" );
	            }
	        },
	        close: function() {
	            form[ 0 ].reset();
	        }
	    });
	
	    form = dialog.find( "form" ).on( "submit", function( event ) {
	        event.preventDefault();
	        dialog.dialog( "close" );
	    });
	
	    $( "#btn2" ).button().on( "click", function() {
	    	$( "#dialog-form" ).dialog( "open" );
	    });
	});
	
	
	// 당일 총 운동시간, 소모칼로리 구하기
	function calculateTotalTimeAndCalories() {
	    var totalExTime = 0;
	    var totalExUsedKcal = 0;
		//모든 운동시간 요소를 확인하여 값을 더함
	    $(".ex_time").each(function(){
	    	var val = $(this).val();
	        totalExTime += !isNaN(val) && val != '' ? parseInt(val, 10) : 0;
	    });
		// 모든 소모 칼로리 요소를 확인하여 값을 더함
	    $(".ex_used_kcal").each(function(){
	        totalExUsedKcal += parseInt($(this).text(), 10);
	    });
		
	    let totalHtml = '';
            totalHtml += 
            	'<div class="total ">' +
            	'<div style="width: 10px;"></div>'+
            	'<div style="width: 10px;"></div>'+
                '<div class="totalExtime">'+"&emsp;&emsp;"+totalExTime+'</div>'+
                '<div class="totalExUsedKcal">'+totalExUsedKcal+'</div>'+
	            '</div>';
        $('#total1').html(totalHtml);
		
	}
	
	// 다크모드 시 칼로리계산 이미지 밝기 낮추기 
	function checkDarkMode() {
		var darkModeCheckbox = document.getElementById('darkModeCheckbox');
	    var kcalImg = document.getElementById('kcalImg');
	    
	    if (darkModeCheckbox.checked) {
	        kcalImg.style.filter = 'brightness(50%)'; // 다크모드 ON시 이미지 밝기를 50%로 줄입니다.
	    } else {
	        kcalImg.style.filter = 'brightness(100%)'; // 다크모드 OFF시 이미지 밝기를 원래대로 복구합니다.
	    }
	}
	
	$(document).ready(function() {
		
		checkDarkMode();
		 
		imgSlide(); 
		displayImages();
		// 사진업로드
		$('#ufrm').submit(function(event) {
   			event.preventDefault(); // 기본 제출 동작 방지
   			const form = $(this);
   			const fileInput = form.find('input[type="file"]');
   			const formData = new FormData(form[0]);
   			
   			if (!fileInput.val()) {
		        //alert("파일을 선택해주세요");
		        swal({
	                  title: "주의!",
	                  text: "파일을 선택해주세요",
	                  icon: "warning",
	                  button: "확인",
	             });
		        return;
		    }
			$.ajax({
			    url: '/exUpload', 
			    type: 'POST',
			    data: formData,
			    processData: false,
			    contentType: false,
			    success: function(flag) {
			    	if(flag == 1 ){
			    		//alert("이미지 업로드에 성공했습니다")
			    		swal({
			                  title: "성공!",
			                  text: "이미지 업로드에 성공했습니다",
			                  icon: "success",
			                  button: "확인",
			             });

			    		form[0].reset();
			    	}else{
			    		//alert("이미지 업로드에 실패했습니다")
			    		swal({
			                  title: "실패!",
			                  text: "이미지 업로드에 실패했습니다",
			                  icon: "error",
			                  button: "확인",
			             });

			    	}
			    	imgSlide();
			    	displayImages();
			    },
			    error: function(xhr, status, error) {
			      console.error('요청 실패. 상태 코드:', xhr.status);
			    }
			  });
			});
		
		$('#ubtn').click(function(event) {
			event.preventDefault(); // 기본 제출 동작 방지
			$('#ufrm').submit(); // 폼 제출
		});
		
		//운동삭제
		$(document).on('click', '.exercise-info .dbtn', function(e) {
			e.preventDefault();
		    let parentDiv = $(this).parent();
		    let exerciseName = parentDiv.find('.ex_name').text();
		    let selectedDate = $('#datepicker').val();
		    $.ajax({
		        url: '/deleteExercise',
		        type: 'POST',
		        contentType: 'application/json',
		        data: JSON.stringify({ ex_name: exerciseName, ex_day: selectedDate }),
		        success: function(response) {
		            // 성공하면 리스트를 다시 불러옵니다.
		            fetchExercises(selectedDate);
		        },
		        error: function(error) {
		            console.error('Delete exercise error:', error);
		        }
		    });
		});
		
		//사용자 운동삭제
		$(document).on('click', '.customExercise-info .dbtn', function(e) {
			e.preventDefault();
		    let parentDiv = $(this).parent();
		    let exerciseName = parentDiv.find('.ex_name').text();
		    let selectedDate = $('#datepicker').val();
		    $.ajax({
		        url: '/deleteExercise',
		        type: 'POST',
		        contentType: 'application/json',
		        data: JSON.stringify({ ex_name: exerciseName, ex_day: selectedDate }),
		        success: function(response) {
		            // 성공하면 리스트를 다시 불러옵니다.
		            fetchExercises(selectedDate);
		        },
		        error: function(error) {
		            console.error('Delete customExercise error:', error);
		        }
		    });
		});
		
		// 달력
		var date = new Date();
	
	    // 'yyyy-mm-dd' 형태의 문자열로 변환
	    var day = ("0" + date.getDate()).slice(-2);
	    var month = ("0" + (date.getMonth() + 1)).slice(-2);
	    var today = date.getFullYear() + "-" + month + "-" + day;
	    var selectedDate = $('#datepicker').val();
	    
        $("#datepicker").datepicker({ 
            dateFormat: 'yy-mm-dd',
            onSelect: function(dateText) {
            	fetchExercises(dateText)
            }
        });
	    // 달력의 기본 값을 오늘 날짜로 설정
	    $("#datepicker").datepicker("setDate", today);
	    fetchExercises(today);
	    
	    
		// 운동 다이어로그 내 검색 버튼
		$('#searchButton1').click(function() {
			let searchEx = $("#exerciseName1").val();
			if (searchEx === '') {
		        //alert('운동종목을 입력해주세요');
		        swal({
	                  title: "주의!",
	                  text: "운동종목을 입력해주세요",
	                  icon: "warning",
	                  button: "확인",
	             });
		        return;
		    }
			// 검색한 단어 서버로 보내고 검색결과 데이터 받아옴
		    $.ajax({
		    	url: '/searchExercise',  
		    	type: 'POST',
		    	data: { mat_name: searchEx },
		    	success: function(data) {
		    		let searchResultsHtml = '';
		    		data.forEach(function(matTO) {
		    			// 각 검색 결과를 HTML 문자열로 변환합니다.
		    			searchResultsHtml += '<div><input type="checkbox" class="select-checkbox" value="' + matTO.mat_name + '"> ' + matTO.mat_name + '</div>';
		    		});
		    		// 검색 결과를 화면에 표시합니다.
		    		$('#exerciseDiv1').html(searchResultsHtml);
		    	},
		    	error: function(jqXHR, textStatus, errorThrown) {
		    		// 오류 처리
		    		console.error('Search error:', errorThrown);
		    	}
		    });
		    
		});
		
		$('#exerciseName1').on('keydown', function(e) {
		    if (e.which == 13) {  // 'Enter' 키의 키코드는 13입니다.
		        $('#searchButton1').click();  // 'Enter' 키를 누르면 '검색' 버튼을 클릭한 것처럼 동작합니다.
		    }
		});
		
		// 전체적용버튼-운동 시간대비 소모칼로리 계산하여 db저장후 출력
		$('#applyAll').click(function() {
			let selectedDate = $('#datepicker').val();
		    const exerciseItems = [];
		    $('.exercise-item .exercise-info').each(function() {
		        const exerciseInfo = $(this);
		        const ex_name = $('.ex_name', exerciseInfo).text();
		        const ex_time = $('.ex_time', exerciseInfo).val();
		        exerciseItems.push({ ex_name, ex_time });
		    });
		    $.ajax({
		        url: '/calculateCalories',
		        type: 'POST',
		        contentType: 'application/json',
		        data: JSON.stringify({ exerciseItems: exerciseItems, selectedDate: selectedDate }),
		        success: function(data) {
		            
		            $('.exercise-item .exercise-info').each(function(i) {
		                const exerciseInfo = $(this);
		                $('.ex_used_kcal', exerciseInfo).text(data[i].ex_used_kcal);
		            });
		            // 계산된 소모 칼로리 적용 후 총 운동시간, 소모 칼로리 업데이트
		            calculateTotalTimeAndCalories();
		            //alert("운동 시간 대비 소모 칼로리가 계산되었습니다")
		            swal({
		                  title: "성공!",
		                  text: "운동 시간 대비 소모 칼로리가 계산되었습니다",
		                  icon: "success",
		                  button: "확인",
		             });

		        },
		        error: function(jqXHR, textStatus, errorThrown) {
		            console.error('Calculation failed:', errorThrown);
		            console.error('Server response:', jqXHR.responseText);
		        }
		    });
		});
		
		
	});