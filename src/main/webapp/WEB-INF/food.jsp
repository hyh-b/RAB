<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>음식 다이어리</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">

<!-- 구글 사이드 상단 Menu 글씨체-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Lugrasimo&display=swap" rel="stylesheet">

<!-- 구글 사이드 글씨체-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Lugrasimo&display=swap" rel="stylesheet">


<!-- 이미지 아이콘 cdn -->
<script src="https://kit.fontawesome.com/efe58e199b.js" crossorigin="anonymous"></script>

<!-- alert css -->
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<style type="text/css">
	
	.theme1 {margin-bottom:30px; border:0px; height:5px; background: linear-gradient(to left, transparent, rgba(255,255,255,.5), transparent);}
	
	/*============ 사이드 로고 메뉴 폰트 ==========*/
	h3.mb-4.ml-4.text-sm.font-medium.text-bodydark2 {
        font-size: 30px;
		font-family: 'Cuprum', sans-serif;
    }
	/*=====================================*/
    
	/*============ 사이드 (공지사항 , 게시판 , 식단 , 운동 , 내정보 , 로그아웃) ==========*/
    h1 {
	    font-size: 25px;
     	font-family: 'Josefin Sans', sans-serif;
	}
	/*===================================================================*/
	
	/*========================================================== 로켓 이미지 바운스 조절====================================================*/	
	@keyframes bounce {
	    0%, 20%, 50%, 80%, 100% {
	        transform: translateY(0);
	    }
	    40% {
	        transform: translateY(-20px);
	    }
	    60% {
	        transform: translateY(-10px);
	    }
	}
	
	.bounce:hover {
	    animation: bounce 1s infinite;
	}
	/*================================================================================================================================*/	
	
	/*=========================================================== 다이어로그 크기 조절 css ==================================================*/
 	.ui-dialog {
	    max-width: 90%; 
	    min-width: 300px; 
	    width: auto !important; 
	}
	
	.ui-dialog-content {
	    overflow-y: auto;
	    max-height: 70vh; 
	}
		
	/*================================================================================================================================*/
	
	/*========================================================= 사진 이미지 크기 , 버튼 css =================================================*/
	.fileInput {
	  border-bottom: 4px solid lightgray;
	  border-right: 4px solid lightgray;
	  border-top: 1px solid black;
	  border-left: 1px solid black;
	  padding: 10px;
	  margin: 15px;
	  cursor: pointer;
	}
	
	.imgPreview {
	  text-align: center;
	  margin: 5px 15px;
	  height: 200px;
	  width: 500px;
	  border-left: 1px solid gray;
	  border-right: 1px solid gray;
	  border-top: 5px solid gray;
	  border-bottom: 5px solid gray;
	}
	
	.imgPreview img {
	  width: 100%;
	  height: 100%;
	}
	
	.previewText {
	  width: 100%;
	  margin-top: 20px;
	}
	
	.submitButton {
	  padding: 12px;
	  margin-left: 10px;
	  background: white;
	  border: 4px solid lightgray;
	  border-radius: 15px;
	  font-weight: 700;
	  font-size: 10pt;
	  cursor: pointer;
	}
	
	.submitButton:hover {
	  background: #efefef;
	}
	
	.centerText {
	  text-align: center;
	  width: 500px;
	}
	/*================================================================================================================================*/

</style>
<style type="text/css">

	.radio-buttons {
    	display: flex; 
  	}
  	
  	.btn {
    	margin-right: 10px; 
  	}
  	
  	.nutrient-table {
	  	border-collapse: collapse;
	}
	
	.nutrient-table td {
	  	padding: 5px;
	}
	
	.spacer-row td {
	  	height: 10px;
	  	padding: 0;
	  	border: none;
	}
	
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<!-- 이미지 업로드를 위해 필요한 API -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/react/16.14.0/umd/react.development.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/react-dom/16.14.0/umd/react-dom.development.js"></script>
<script>
	$(document).ready(function() {
		
		$( function() {
			$( "#datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });
		});
		
	//==================================================== 식단 등록 =================================================================
		// 아침 , 점심 ,저녁 의 div 삭제 이벤트 전역변수
		let divId = 1;
		// 아침 , 점심 , 저녁 deleteBtn 이벤트
		$(document).on('click', '.delete-btn', function() {
	        let targetDiv = $(this).data('target');
	        $('#' + targetDiv).remove();
	    });
		
		$('#submitMeal').on('click', function(){
			let mealTime = $('#mealTime').val();
			let url;
			let resultFood = 'resultFood1';
			let selectedMeal = $('#mealSelect').val();

			if (selectedMeal === "") {
				swal({
		    		  title: "실패!",
		    		  text: "아침 , 점심 , 저녁 중 선택을 하여 등록해야합니다.",
		    		  icon: "error",
		    		  button: "확인",
		    	});
				return;
			}

			if (selectedMeal === "breakfast") {
				url = 'breakfastFoodData';
			} else if (selectedMeal === "lunch") {
				url = 'lunchFoodData';
			} else if (selectedMeal === "dinner") {
				url = 'dinnerFoodData';
			}

			submitData(resultFood, url);
		});
		
		function submitData(resultFood, url) {
		    let formData = new FormData($('form')[0]);
		    let additionalData = [];
		    let selectedDate = $("#datepicker").datepicker("getDate");
		    let formattedDate = $.datepicker.formatDate('yy-mm-dd', selectedDate);
		    
		    if (!selectedDate) {
		    	swal({
		    		  title: "실패!",
		    		  text: "날짜를 선택해주세요!",
		    		  icon: "error",
		    		  button: "확인",
		    	});
		        return;
		    }
		    
		    if ($('#' + resultFood).children().length === 0) {
		        swal({
		    		  title: "실패!",
		    		  text: "음식을 조회 후 등록 버튼을 눌러주세요!",
		    		  icon: "error",
		    		  button: "확인",
		    	});
		        return; // 함수 실행 종료
		    }

		    $('#'+resultFood+' > div').each(function() {
		        let f_name = $(this).find('input[name="f_name"]').val();
		        let f_carbohydrate_g = $(this).find('input[name="f_carbohydrate_g"]').val();
		        let f_protein_g = $(this).find('input[name="f_protein_g"]').val();
		        let f_fat_g = $(this).find('input[name="f_fat_g"]').val();
		        let f_cholesterol_mg = $(this).find('input[name="f_cholesterol_mg"]').val();
		        let f_sodium_mg = $(this).find('input[name="f_sodium_mg"]').val();
		        let f_sugar_g = $(this).find('input[name="f_sugar_g"]').val();
		        let f_kcal = $(this).find('input[name="f_kcal"]').val();
		        additionalData.push({
		            f_name: f_name,
		            f_carbohydrate_g: f_carbohydrate_g,
		            f_protein_g : f_protein_g,
		            f_fat_g : f_fat_g,
		            f_cholesterol_mg : f_cholesterol_mg,
		            f_sodium_mg : f_sodium_mg,
		            f_sugar_g : f_sugar_g,
		            f_kcal : f_kcal
		        });
		    });
			
		    formData.append('formattedDate', formattedDate);
		    formData.append('additionalData', JSON.stringify(additionalData));

		    $.ajax({
		        url : url,
		        type : 'post',
		        data : formData,
		        processData: false,
		        contentType: false,
		        dataType : 'json',
		        success : function(json){
// 		            console.log('아침 클릭 '+json);
// 		            console.log('아침 클릭 '+json.flag);
// 		            console.log('아침 클릭 '+json.main_flag_b);
		            if(json.flag == '1'){
		                swal({
				    		  title: "성공!",
				    		  text: "등록 성공입니다.",
				    		  icon: "success",
				    		  button: "확인",
				    	});
		                // 등록 성공 후 div 제거
		                $('#' + resultFood).empty(); 
		            } else {
		                swal({
				    		  title: "실패!",
				    		  text: "음식을 조회 후 등록 버튼을 눌러주세요!",
				    		  icon: "error",
				    		  button: "확인",
				    	});
		            }
		        },
		        error : function(e){
		            swal({
			    		  title: "에러",
			    		  text: '[에러]'+e.status,
			    		  icon: "error",
			    		  button: "확인",
			    	});
		        }
		    });
		} 
		
	//==================================================== 식단 메모 =================================================================
		
		$('#foodName1').on('keypress', function(e) {
	        if (e.which == 13) {
	            e.preventDefault();  
	        	$('#searchButton1').click(); 
	        }
	    });
		$('#searchButton1').click(function() {
		    const data = $('#foodName1').val();
		    console.log(data);
		
		    if (data === '') {
		        swal({
		    		  title: "주의!",
		    		  text: "검색어를 입력해주세요!",
		    		  icon: "warning",
		    		  button: "확인",
		    	});
		        return;
		    }
		    
		    $.ajax({
		        url: "/foodData",
		        method: "post",
		        data: {
		            data: data
		        },
		        dataType: "json",
		        success: function(json) {
		            console.log(json);
		            if (json.length > 0) {
		                let result = "<table>";
		                $(json).each(function(index, item) {
		                    result += "<tr class='selectable-row'>";
		                    result += "<td><input type='checkbox' class='select-checkbox'></td>";
		                    result += "<td>" + item.f_name + "</td>";
		                    result += "<td style='display: none;'>" + item.f_carbohydrate_g + "</td>";
		                    result += "<td style='display: none;'>" + item.f_protein_g + "</td>";
		                    result += "<td style='display: none;'>" + item.f_fat_g + "</td>";
		                    result += "<td style='display: none;'>" + item.f_cholesterol_mg + "</td>";
		                    result += "<td style='display: none;'>" + item.f_sodium_mg + "</td>";
		                    result += "<td style='display: none;'>" + item.f_sugar_g + "</td>";
		                    result += "<td style='display: none;'>" + item.f_kcal + "</td>";
		                    result += "</tr>";
		                });
		                result += "</table>";
		                $('#foodComent1').html(result);
		                $('#foodName1').val('');
		                // 선택 가능한 행에 클릭 이벤트 추가
		                $('.selectable-row').click(function() {
		                    $(this).toggleClass('selected');
		                });
		            } else {
		                swal({
				    		  title: "실패!",
				    		  text: "데이터가 없습니다. 다시 입력해주세요!",
				    		  icon: "error",
				    		  button: "확인",
				    	});
		            }
		        },
		        error: function(e) {
		        	swal({
			    		  title: "에러",
			    		  text: '[에러]'+e.status,
			    		  icon: "error",
			    		  button: "확인",
			    	});
		        }
		    });
		});
		
		$("#dialogContainer1").dialog({
		    autoOpen: false,
		    modal: true,
		    width: 350,
		    height: 400,
		    buttons: {
		        '취소': function() {
		        	$('#foodComent1').empty();
		            $(this).dialog('close');
		        },
				"확인": function() {
					
					if ($('.select-checkbox:checked').length == 0) {
		                swal({
				    		  title: "실패!",
				    		  text: "해당 음식을 체크 누른 후 확인을 눌러주세요!",
				    		  icon: "error",
				    		  button: "확인",
				    	});
		                return false;
		            }
					
				    let selectedData = [];
				    $('.select-checkbox:checked').each(function() {
				        let rowData = [];
				        $(this).closest('tr').find('td').each(function() {
				            rowData.push($(this).text());
				        });
				        selectedData.push(rowData);
				    });
				
				    if (selectedData.length > 0) {
				        selectedData.forEach(function(dataRow) {
				            let rowId = "generated-div-" + divId;
				            let result = '<div id="' + rowId + '" class="row-div">';
				            result += '<div class="tt" style="display: flex; justify-content: space-between;padding-bottom: 20px;">';
				            result += '<div>';
				            result += '<table>';
				            result += '<thead>';
				            result += '<tr>';
				            result += '<td><input type="text" name="f_name" placeholder="Default Input" style="width: 142px" readonly="readonly" class="w-1/4 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[1] + '"/><button class="delete-btn" data-target="' + rowId + '" style="margin-left: 10px;"><i class="fas fa-times"></i></button></td>';
				            result += '</tr>';
				            result += '</thead>';
				            result += '</table>';
				            result += '</div>';
				            result += '<table cellpadding="0" cellspacing="0" style="position:relative;left:-2px;">';
				            result += '<thead></thead>';
				            result += '<tbody>';
				            result += '<tr>';
				            result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_carbohydrate_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[2] + '"/></td>';
				            result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_protein_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[3] + '"/></td>';
				            result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_fat_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[4] + '"/></td>';
				            result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_cholesterol_mg" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[5] + '"/></td>';
				            result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_sodium_mg" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[6] + '"/></td>';
				            result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_sugar_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[7] + '"/></td>';
		                    result += '<td class="main" style="color: #000; font-weight: bold;"><input type="text" style="width:92px;" name="f_kcal" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[8] + '"/></td>';
		                    result += '</tr>';
		                    result += '</tbody>';
		                    result += '</table>';
		                    result += '</div>';
		                    result += '</div>';
		                    $('#resultFood1').append(result);
		                    divId++;
		                });
				        $('#foodComent1').empty();
				        $('.select-checkbox').prop('checked', false);
		                $(this).dialog("close");
		            }
		        }
		    }
		});
		
		$("#dialogContainer2").dialog({
		    autoOpen: false,
		    modal: true,
		    width: 600,
		    height: 874,
		    buttons: {
		        '취소': function () {
		        	imageUpload.file = null;
	                imageUpload.imagePreviewUrl = '';
	                imageUpload.render();
	                $('#foodTable').empty();
		            $(this).dialog('close');
		        },
		        "확인": function () {
		            if ($('.select-checkbox:checked').length === 0) {
		                swal({
				    		  title: "실패!",
				    		  text: "해당 음식을 체크한 후 확인을 눌러주세요!",
				    		  icon: "error",
				    		  button: "확인",
				    	});
		                return false;
		            }
	
		            let selectedData = [];
		            $('.select-checkbox:checked').each(function () {
		                let rowData = [];
		                $(this).closest('tr').find('td').each(function () {
		                    rowData.push($(this).text());
		                });
		                selectedData.push(rowData);
		            });
	
		            if (selectedData.length > 0) {
		                selectedData.forEach(function (dataRow) {
		                    let rowId = "generated-div-" + divId;
		                    let result = '<div id="' + rowId + '" class="row-div">';
		                    result += '<div class="tt" style="display: flex; justify-content: space-between;padding-bottom: 20px;">';
		                    result += '<div>';
		                    result += '<table>';
		                    result += '<thead>';
		                    result += '<tr>';
		                    result += '<td><input type="text" name="f_name" placeholder="Default Input" style="width: 142px" readonly="readonly" class="w-1/4 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[1] + '"/><button class="delete-btn" data-target="' + rowId + '" style="margin-left: 10px;"><i class="fas fa-times"></i></button></td>';
		                    result += '</tr>';
		                    result += '</thead>';
		                    result += '</table>';
		                    result += '</div>';
		                    result += '<table cellpadding="0" cellspacing="0" style="position:relative;left:-2px;">';
		                    result += '<thead></thead>';
		                    result += '<tbody>';
		                    result += '<tr>';
		                    result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_carbohydrate_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[2] + '"/></td>';
		                    result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_protein_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[3] + '"/></td>';
		                    result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_fat_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[4] + '"/></td>';
		                    result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_cholesterol_mg" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[5] + '"/></td>';
		                    result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_sodium_mg" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[6] + '"/></td>';
		                    result += '<td class="main" style="padding-right: 17px;"><input style="width:92px;" type="text" name="f_sugar_g" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[7] + '"/></td>';
		                    result += '<td class="main" style="color: #000; font-weight: bold;"><input type="text" style="width:92px;" name="f_kcal" readonly="readonly" placeholder="Default Input" class="w-1/4 md:w-1/2 rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" value="' + dataRow[8] + '"/></td>';
		                    result += '</tr>';
		                    result += '</tbody>';
		                    result += '</table>';
		                    result += '</div>';
		                    result += '</div>';
		                    $('#resultFood1').append(result);
		                    divId++;
		                });
		                imageUpload.file = null;
		                imageUpload.imagePreviewUrl = '';
		                imageUpload.render();
		                $('#foodTable').empty();
		                $('.select-checkbox').prop('checked', false);
		                $(this).dialog("close");
		            }
		        }
		    }
		});
	//=================================================== 식단 메모 끝 =================================================================
	
	//================================================ 이미지 업로드 부분 시작 ==============================================================
		class ImageUpload {
		  constructor() {
		    this.file = null;
		    this.imagePreviewUrl = '';
		    this.responseData = null;
		  }
		  
		  // form이 submit 되었을떄 호출되며 선택된 이미지를 서버(Controller)에 업로드 하는 작업!!
		  _handleSubmit() {
			  
		  	if (!this.file) {
			    swal({
			    	  title: "주의!",
			    	  text: "사진을 선택 후 업로드 해주세요!",
			    	  icon: "warning",
			    	  button: "확인",
			    });
				return;
			}  
		  	const formData = new FormData();
		    formData.append('image', this.file);
	
		    $.ajax({
	   	        url: '/api/upload',
	   	        type: 'POST',
	   	        data: formData,
	   	        cache: false,
	   	        contentType: false,
	   	        processData: false,
	   	        dataType : 'json',
	   	        success: (json) => {
	   	        	console.log(json)
	   	        	this.responseData = json;
	   	            this.render();
	   	        },
	   	        error: function(e) {
	   	        	swal({
			    		  title: "에러",
			    		  text: '[에러]'+e.status,
			    		  icon: "error",
			    		  button: "확인",
			    	});
	   	        }
	   	    });
		  }
		
		  
		  _handleImageChange(e) {
		    e.preventDefault();
		
		    let reader = new FileReader();
		    let file = e.target.files[0];
		
		    if (!file.type.startsWith('image/')) {
		      swal({
		    	  title: "실패!",
		    	  text: "이미지 파일만 업로드할 수 있습니다.",
		    	  icon: "warning",
		    	  button: "확인",
		      });
	
		      this.file = null;
		      this.imagePreviewUrl = '';
		      this.render();
		      return;
		    }
		
		    reader.onloadend = () => {
		      this.file = file;
		      this.imagePreviewUrl = reader.result;
		      this.render();
		    }
		
		    reader.readAsDataURL(file);
		  }
		
	     	  //========================================= UI 에서 이미지 미리보기 기능 시작 ====================================================
		  render() {
		    let $imagePreview = null;
		    let fileName = '';
		    if (this.imagePreviewUrl && this.file && this.file.type.startsWith('image/')) {
		      $imagePreview = $('<img>').attr('src', this.imagePreviewUrl);
		      fileName = this.file.name;
		    } else {
		      $imagePreview = $('<div>').addClass('previewText').text('미리 보기할 이미지를 선택해주세요');
		    }
		
		    const $previewComponent = $('<div>').addClass('previewComponent').append(
		      $('<form>').on('submit', (e) => {
		        e.preventDefault();
		        this._handleSubmit();
		      }).append(
		        $('<input>').addClass('fileInput').attr('type', 'file').on('change', (e) => this._handleImageChange(e)),
		        $('<button>').addClass('submitButton').attr('type', 'submit').text('이미지 업로드').on('click', (e) => {
		          e.preventDefault();
		          this._handleSubmit();
		        })
		      ),
		      $('<div>').addClass('imgPreview').css('height', '310px').append($imagePreview)
		    );
		    
		    //========================================== Ajax에서 responseData에 데이터를 넘겨서 뿌려주기 시작 ===============================
		    
		    if (this.responseData) {
			    const table = $('<table>').attr('id', 'foodTable').css({
			        'border-collapse': 'collapse', 
			        'width': '100%'
			    });
			
			    const message = $('<h3>').text('사진에 해당하는 메뉴를 체크해주세요.').css({
			        'text-align': 'center',
			        'margin-top': '20px'
			    });
			
			    this.responseData.forEach((foodInfo) => {
			        const row = $('<tr>').addClass('selectable-row');
			        row.append($('<td>').css({
			            'border': '1px solid black',
			            'text-align': 'center'
			        }).html('<input type="checkbox" class="select-checkbox">'));
			        row.append($('<td>').text(foodInfo.foodName).css({
			            'border': '1px solid black',
			            'text-align': 'center'
			        }));
			        row.append($('<td>').css('display', 'none').text(foodInfo.carbohydrates).css('border', '1px solid black'));
			        row.append($('<td>').css('display', 'none').text(foodInfo.protein).css('border', '1px solid black'));
			        row.append($('<td>').css('display', 'none').text(foodInfo.fat).css('border', '1px solid black'));
			        row.append($('<td>').css('display', 'none').text(foodInfo.cholesterol).css('border', '1px solid black'));
			        row.append($('<td>').css('display', 'none').text(foodInfo.sodium).css('border', '1px solid black'));
			        row.append($('<td>').css('display', 'none').text(foodInfo.sugar).css('border', '1px solid black'));
			        row.append($('<td>').css('display', 'none').text(foodInfo.kcal).css('border', '1px solid black'));
			        table.append(row);
			    });
			
			    $previewComponent.append(message);
			    $previewComponent.append(table);
			}
		    //========================================== Ajax에서 responseData에 데이터를 넘겨서 뿌려주기 끝 =================================
	
		    	
		    //========================================= UI 에서 이미지 미리보기 기능 끝 ====================================================
		    
		    $('#mainApp').empty().append($previewComponent);
		  }
		}
		
		const imageUpload = new ImageUpload();
		imageUpload.render();
    
		//=================================================== 이미지 업로드 부분 끝 ==============================================================
	
	
		//=================================================== 다이어로그 업로드 부분 시작 ==============================================================
		$( '#btn1' ).button().on( 'click', function() {
			$( '#dialogContainer1' ).dialog( 'open' ); 
		});
		
		$( '#btn2' ).button().on( 'click', function() {
			$( '#dialogContainer2' ).dialog( 'open' ); 
		});
	
		//=================================================== 다이어로그 업로드 부분 끝 ================================================================
			
		// ========================================= 다이어로그 제어 부분 =========================================
		$(window).resize(function() {
		    let wWidth = $(window).width();
		    let dWidth = wWidth * 0.8;
		    let wHeight = $(window).height();
		    let dHeight = wHeight * 0.8;
	
		    $("#dialogContainer1").dialog("option", "width", dWidth);
		    $("#dialogContainer1").dialog("option", "height", dHeight);
	
		    $("#dialogContainer2").dialog("option", "width", dWidth);
		    $("#dialogContainer2").dialog("option", "height", dHeight);
		});
		
		
		let initialWidth = $(window).width() * 0.8;
		let initialHeight = $(window).height() * 0.8;
		// =================================================================================================	
});
</script>

</head>
<body
  x-data="{ page: 'profile', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
  x-init="
          darkMode = JSON.parse(localStorage.getItem('darkMode'));
          $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
  :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}">
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
  <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5" style="padding-left: 59px; padding-bottom: 0px;padding-top: 40px;">
    <a href="/main.do">
<!--       <img src="src/images/logo/배경로고2.png" width="100%" height="100%" /> -->
		<i class="fa-solid fa-rocket bounce fa-10x" style="padding-top: 20px;"></i>
    </a>

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

  <div class="no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear">
    <!-- Sidebar Menu -->
    <nav
      class="mt-5 py-4 px-4 lg:mt-9 lg:px-6"
      x-data="{selected: 'Dashboard'}"
      x-init="
        selected = JSON.parse(localStorage.getItem('selected'));
        $watch('selected', value => localStorage.setItem('selected', JSON.stringify(value)))"
    >
      <!-- Menu Group -->
      <div>
	      <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2" style="padding-left: 45px; padding-top: 0px;">Menu</h3>
		  <hr class="theme1">
	
	      <ul class="mb-6 flex flex-col gap-1.5">
	        <!-- Menu Item Dashboard -->
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	      <a
	         href="notice_board.do"
	         class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	         style="padding-left: 30px;"
	       >
	       <i class="fa-solid fa-circle-info"></i>
	       <path
	         d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	         fill=""
	       />
	       <path
	         d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	         fill=""
	       />
	       </svg>
	       <h1>공지사항</h1>
	      </a>
	     </li>
	     
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	       <a
	          href="board_list1.do"
	          class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	          style="padding-left: 30px;"
	        >
	          <i class="fa-solid fa-users"></i>
	          <path
	            d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	            fill=""
	          />
	          <path
	            d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	            fill=""
	          />
	          </svg>
	          <h1>게시판</h1>
	        </a>
	      </li>

	      <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	        <a
	           href="food.do"
	           class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	           style="padding-left: 30px;"
	         >
	           <i class="fa-solid fa-bowl-food"></i>
	           <path
	             d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	             fill=""
	           />
	           <path
	             d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	             fill=""
	           />
	           </svg>
	           <h1>음식</h1>
	         </a>
	      </li>
	      
	      <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	         <a
	            href="exercise.do"
	            class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	            style="padding-left: 30px;"
	          >
	            <i class="fa-solid fa-dumbbell"></i>
	            <path
	              d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	              fill=""
	            />
	            <path
	              d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	              fill=""
	            />
	            </svg>
	            <h1>운동</h1>
	          </a>
	       </li>
			<br/><br/>
			<h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2" style="padding-left: 45px; padding-top: 20px;">Others</h3>
          	<hr class="theme1">
	          <!-- Menu Item Settings -->
	        <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	          <a
	              href="profile.do"
	              class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	              style="padding-left: 30px;"
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
	                  d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	                  fill=""
	                />
	                <path
	                  d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	                  fill=""
	                />
	              </svg>
	              <h1>프로필</h1>
	            </a>
	        </li>
	        <li>
				<button class="flex items-center gap-3.5 py-4 px-6 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base">
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
	            <a href="/klogout.do"><h1>로그아웃</h1></a>
	          </button>
			</li>
          
          <!-- Menu Item Settings -->
        </ul>
      </div>
      </nav>
  </div>
</aside>

    <!-- ===== Sidebar End ===== -->

    <!-- ===== Content Area Start ===== -->
    <div class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
      <!-- ===== Header Start ===== -->
      <header class="sticky top-0 z-999 flex w-full bg-white drop-shadow-1 dark:bg-boxdark dark:drop-shadow-none">
  		<div class="flex flex-grow items-center justify-between py-4 px-4 shadow-2 md:px-6 2xl:px-11">
    <div class="flex items-center gap-2 sm:gap-4 lg:hidden">
      <!-- Hamburger Toggle BTN 로고메뉴-->
      <button
        class="z-99999 block rounded-sm border border-stroke bg-white p-1.5 shadow-sm dark:border-strokedark dark:bg-boxdark lg:hidden"
        @click.stop="sidebarToggle = !sidebarToggle"
      >
      	<!-- 아이콘을 여기에 추가 -->
    	<i class="fa-solid fa-rocket bounce fa-xl"></i>
      </button>
      <!-- Hamburger Toggle BTN 히든-->
      <a class="block flex-shrink-0 lg:hidden" href="index.html">
<!--         <img src="src/images/logo/logo-icon.svg" alt="Logo" /> -->
<!-- 		<i class="fa-solid fa-rocket bounce fa-xl"></i> -->
      </a>
    </div>
    
    <div class="hidden sm:block">
    </div>

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
                    d="M8.00008 15.3067C7.63341 15.3067 7.33342 15.0334 7.33342 14.6667V14.6134C7.33342 14.2467 7.63341 13.9467 8.00008 13.9467C8.36675 13.9467 8.66675 14.2467 8.66675 14.6134C8.66675 14.9801 8.36675 15.3067 8.00008 15.3067ZM12.7601 13.4267C12.5867 13.4267 12.4201 13.3601 12.2867 13.2334L12.2001 13.1467C11.9401 12.8867 11.9401 12.4667 12.2001 12.2067C12.4601 11.9467 12.8801 11.9467 13.1401 12.2067L13.2267 12.2934C13.4867 12.5534 13.4867 12.9734 13.2267 13.2334C13.1001 13.3601 12.9334 13.4267 12.7601 13.4267ZM3.24008 13.4267C3.06675 13.4267 2.90008 13.3601 2.76675 13.2334C2.50675 12.9734 2.50675 12.5534 2.76675 12.2934L2.85342 12.2067C3.11342 11.9467 3.53341 11.9467 3.79341 12.2067C4.05341 12.4667 4.05341 12.8867 3.79341 13.1467L3.70675 13.2334C3.58008 13.3601 3.40675 13.4267 3.24008 13.4267ZM14.6667 8.66675H14.6134C14.2467 8.66675 13.9467 8.36675 13.9467 8.00008C13.9467 7.63341 14.2467 7.33342 14.6134 7.33342C14.9801 7.33342 15.3067 7.63341 15.3067 8.00008C15.3067 8.36675 15.0334 8.66675 14.6667 8.66675ZM1.38675 8.66675H1.33341C0.966748 8.66675 0.666748 8.36675 0.666748 8.00008C0.666748 7.63341 0.966748 7.33342 1.33341 7.33342C1.70008 7.33342 2.02675 7.63341 2.02675 8.00008C2.02675 8.36675 1.75341 8.66675 1.38675 8.66675ZM12.6734 3.99341C12.5001 3.99341 12.3334 3.92675 12.2001 3.80008C11.9401 3.54008 11.9401 3.12008 12.2001 2.86008L12.2867 2.77341C12.5467 2.51341 12.9667 2.51341 13.2267 2.77341C13.4867 3.03341 13.4867 3.45341 13.2267 3.71341L13.1401 3.80008C13.0134 3.92675 12.8467 3.99341 12.6734 3.99341ZM3.32675 3.99341C3.15341 3.99341 2.98675 3.92675 2.85342 3.80008L2.76675 3.70675C2.50675 3.44675 2.50675 3.02675 2.76675 2.76675C3.02675 2.50675 3.44675 2.50675 3.70675 2.76675L3.79341 2.85342C4.05341 3.11342 4.05341 3.53341 3.79341 3.79341C3.66675 3.92675 3.49341 3.99341 3.32675 3.99341ZM8.00008 2.02675C7.63341 2.02675 7.33342 1.75341 7.33342 1.38675V1.33341C7.33342 0.966748 7.63341 0.666748 8.00008 0.666748C8.36675 0.666748 8.66675 0.966748 8.66675 1.33341C8.66675 1.70008 8.36675 2.02675 8.00008 2.02675Z"
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
          <!-- Dark Mode Toggler -->
        </li>

        <!-- Notification Menu Area -->
        
        <!-- Notification Menu Area -->

        <!-- Chat Notification Area -->
        
        <!-- Chat Notification Area -->
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

              >${zzinnickname}</span
            >
            <!-- 
            <span class="block text-xs font-medium"></span>
			 -->	          
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
                style="padding-left: 5px;"
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
                    d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
                    fill=""
                  />
                  <path
                    d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
                    fill=""
                  />
                </svg>
                프로필
              </a>
            </li>
          </ul>
          
          
          
          
          <button class="flex items-center gap-3.5 py-4 px-6 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base">
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
        <!-- =============================== div 시작 ========================= -->
		<div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">

        <!-- =============================== 타이틀 시작========================= -->

		<div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-center">
		  <h4 class="text-title-md2 font-bold text-black dark:text-white" style="padding-left: 30px; margin: auto">
		    식단 메모
		  </h4>
		</div>
        <!-- =============================== 타이틀 끝 ========================= -->

        <hr style="padding-bottom: 30px"/>

        <!-- =============================== 아침 ========================= -->
          	
        <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark" >
        	<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark d-flex justify-content-end">
				<div class="flex items-center">
					<div>
						<select id="mealSelect" class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
							<option value="breakfast">아침</option>
							<option value="lunch">점심</option>
							<option value="dinner">저녁</option>
						</select>
					</div>
					<button id="btn1">
						<img src="https://m.ftscrt.com/static/images/foodadd/FA_add.png" width="17px" height="17px">
					</button>

					<button id="btn2" >
					    <i class="fas fa-image"style="font-size: 17px;"></i>
					</button>
					<div>
						<!-- 날짜를 선택할 수 있는 입력 요소를 추가합니다. -->
						<input type="text" id="datepicker" placeholder="날짜 선택" class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark"/>
					</div>
					<div>
						<button id="submitMeal">등록</button>
					</div>
					<div id="dialogContainer1" title="검색">
						<input type="text" id="foodName1" placeholder="검색어를 입력하세요">
						<button id="searchButton1">검색</button>
						<div id="foodComent1"></div>
					</div>
					<div id="dialogContainer2">
						<div id="mainApp">
						  <div class="centerText"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
				<div class="flex items-center">
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-left: 50px; width: 650px;">
			    		음식명
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-right: 40px;">
			    		탄수화물
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-right: 40px;">
			    		단백질
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-right: 55px;">
			    		지방
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-right: 40px;">
			    		콜레스토롤
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-right: 50px;">
			    		나트륨
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-right: 50px;">
			    		당
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4">
			    		칼로리
			    	</label>
				</div>
			</div>
            <div class="flex flex-col gap-5.5 p-6.5">
            	<div>
		            <form action="#" method="post" name="ffrm">
						<input type="hidden" name="seq" id="seq" value="${seq}" />
						<div id="resultFood1"></div>
					</form>
	        	</div>
        	</div>
        </div>
        </div> 
        <!-- =============================== 식단메모 끝 =========================== -->
        
        <!-- =============================== div 끝 =========================== -->
	  </main> 
      <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
  </div>
  <!-- ===== Page Wrapper End ===== -->
<script defer src="bundle.js"></script></body>

</html>