<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="seq" value="${requestScope.seq}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>음식 다이어리</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<style type="text/css">
	
/* 	main { */
/*         overflow: hidden; */
/* 	}	 */
	/*  메인 스크롤 고정  */
	.radio-buttons {
    	display: flex; /* 가로 배치를 위해 flexbox 사용 */
  	}
  	
  	.btn {
    	margin-right: 10px; /* 버튼 사이의 간격 조정 */
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
	
    .accordion {
	    margin-bottom: 10px;
	}
	
	.accordion-title {
	    cursor: pointer;
	    padding: 5px;
	}
	
	.accordion-content {
	    display: none;
	    margin-top: 10px;
	}
    
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>

<script>
  	
	$(document).ready(function() {
		
		// 아침 , 점심 ,저녁 의 div 삭제 이벤트 전역변수
		let divId = 1;
		// 아침 , 점심 , 저녁 deleteBtn 이벤트
		$(document).on('click', '.delete-btn', function() {
	        let targetDiv = $(this).data('target');
	        $('#' + targetDiv).remove();
	    });
		
		
	//==================================================== 아침 =================================================================
	$('#searchButton1').click(function() {
	    const data = $('#foodName1').val();
	    console.log(data);
	
	    if (data === '') {
	        alert('검색어를 입력해주세요!');
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
	                alert("데이터가 없습니다. 다시 입력해주세요!");
	            }
	        },
	        error: function(e) {
	            alert("에러 발생: " + e.status);
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
		            $(this).dialog('close');
		        },
				"확인": function() {
					
					if ($('.select-checkbox:checked').length == 0) {
		                alert('해당 음식을 체크 누른 후 확인을 눌러주세요!');
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
		
		
		$('#fbtn1').on('click',function(){
			
	        let formData = new FormData($('form')[0]);
	        let additionalData = [];
	        
	        if ($('#resultFood1').children().length === 0) {
	            alert('음식을 조회 후 등록 버튼을 눌러주세요!');
	            return; // 함수 실행 종료
	        }
	        
	        $('#resultFood1 > div').each(function() {
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

	        formData.append('additionalData', JSON.stringify(additionalData));
	        
	        
	        $.ajax({
	            url : '/breakfastFoodData',
	            type : 'post',
	            data : formData,
	            processData: false,
	            contentType: false,
	            dataType : 'json',
	            success : function(json){
	                console.log('아침 클릭 '+json);
	                if(json.flag == '1'){
	                	alert('등록 성공입니다.');
	                	// 등록 성공 후 div 제거
	                    $('#resultFood1').empty();
	                } else {
	                	alert('음식을 조회 후 등록 버튼을 눌러주세요!');
	                }
	            },
	            error : function(e){
	                alert('[에러]'+e.status);
	            }
	        });
	    }); 
		
		
		$( '#btn1' ).button().on( 'click', function() {
			$( '#dialogContainer1' ).dialog( 'open' ); 
		});

		//=========================================================================================================================
		
			
		//================================================ 점심 =====================================================================
		
		$('#searchButton2').click(function() {
		    const data = $('#foodName2').val();
		    console.log(data);
			
		    if (data === '') {
		        alert('검색어를 입력해주세요!');
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
		        	console.log(json)
		            if (json.f_name !== null) {
		                let result = "";
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
		                $('#foodComent2').html(result); 
		                $('#foodName2').val('');
		            } else {
		                alert("데이터가 없습니다. 다시 입력해주세요!");
		            }
		        },
		        error: function(e) {
		            alert("에러 발생: " + e.status);
		        }
		    });
		});

		
		$("#dialogContainer2").dialog({
		    autoOpen: false,
		    modal: true,
		    width: 350,
		    height: 400,
		    buttons: {
		        '취소': function() {
		            $(this).dialog('close');
		        },
				"확인": function() {
					
					if ($('.select-checkbox:checked').length == 0) {
		                alert('해당 음식을 체크 누른 후 확인을 눌러주세요!');
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
		                    $('#resultFood2').append(result);
		                    divId++;
		                });
				        $('#foodComent2').empty();
				        $('.select-checkbox').prop('checked', false);
		                $(this).dialog("close");
		            }
		        }
		    }
		});
		
		$('#fbtn2').on('click',function(){
			
	        let formData = new FormData($('form')[0]);
	        let additionalData = [];
	        
	        if ($('#resultFood2').children().length === 0) {
	            alert('음식을 조회 후 등록 버튼을 눌러주세요!');
	            return; // 함수 실행 종료
	        }
	        
	        $('#resultFood2 > div').each(function() {
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

	        formData.append('additionalData', JSON.stringify(additionalData));
	        
	        
	        $.ajax({
	            url : '/lunchFoodData',
	            type : 'post',
	            data : formData,
	            processData: false,
	            contentType: false,
	            dataType : 'json',
	            success : function(json){
	                console.log('점심에대한 '+json);
	                if(json.flag == '1'){
	                	alert('등록 성공입니다.');
	                	// 등록 성공 후 div 제거
	                    $('#resultFood2').empty();
	                } else {
	                	alert('음식을 조회 후 등록 버튼을 눌러주세요!');
	                }
	            },
	            error : function(e){
	                alert('[에러]'+e.status);
	            }
	        });
	    });
		
		$( '#btn2' ).button().on( 'click', function() {
			$( '#dialogContainer2' ).dialog( 'open' ); 
		});
		
		//=========================================================================================================================

		//================================================ 저녁 =====================================================================
			
		// 저녁의 데이터 검색 Ajax 구문
		$('#searchButton3').click(function() {
		    const data = $('#foodName3').val();
		    console.log(data);
			
		    if (data === '') {
		        alert('검색어를 입력해주세요!');
		        return; 
		   	}
		    
		    $('#foodComent3').empty();
		    
		    $.ajax({
		        url: "/foodData",
		        method: "post",
		        data: {
		            data: data
		        },
		        dataType: "json",
		        success: function(json) {
		        	console.log(json)
		            if (json.f_name !== null) {
		                let result = "";
		                let totalKcal = 0;
		                $(json).each(function(index, item) {
		                    result += "<table>";
		                    result += "<tr>";
		                    result += "<td><input type='checkbox' class='select-checkbox'></td>";
		                    result += "<td>" + item.f_name + "</td>";
		                    result += "<td>" + item.f_carbohydrate_g + "</td>";
		                    result += "<td>" + item.f_protein_g + "</td>";
		                    result += "<td>" + item.f_fat_g + "</td>";
		                    result += "<td>" + item.f_cholesterol_mg + "</td>";
		                    result += "<td>" + item.f_sodium_mg + "</td>";
		                    result += "<td>" + item.f_sugar_g + "</td>";
		                    result += "<td>" + item.f_kcal + "</td>";
		                    result += "</tr>";
		                    result += "</table>";
		                });
		                $('#foodComent3').html(result); 
		                $('#foodName3').val('');
		            } else {
		                alert("데이터가 없습니다. 다시 입력해주세요!");
		            }
		        },
		        error: function(e) {
		            alert("에러 발생: " + e.status);
		        }
		    });
		});
		
		$("#dialogContainer3").dialog({
		    autoOpen: false,
		    modal: true,
		    width: 350,
		    height: 400,
		    buttons: {
		        '취소': function() {
		            $(this).dialog('close');
		        },
		        "확인": function() {
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
		                    $('#resultFood3').append(result);
		                    divId++;
		                });
				        $('#foodComent3').empty();
				        $('.select-checkbox').prop('checked', false);
		                $(this).dialog("close");
		            }
		        }
		    }
		}); 
		
		$('#fbtn3').on('click',function(){
			
	        let formData = new FormData($('form')[0]);
	        let additionalData = [];
	        
	        if ($('#resultFood3').children().length === 0) {
	            alert('음식을 조회 후 등록 버튼을 눌러주세요!');
	            return; // 함수 실행 종료
	        }
	        
	        $('#resultFood3 > div').each(function() {
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

	        formData.append('additionalData', JSON.stringify(additionalData));
	        
	        
	        $.ajax({
	            url : '/dinnerFoodData',
	            type : 'post',
	            data : formData,
	            processData: false,
	            contentType: false,
	            dataType : 'json',
	            success : function(json){
// 	                console.log('저녁 '+json);
	                if(json.flag == '1'){
	                	alert('등록 성공입니다.');
	                	// 등록 성공 후 div 제거
	                    $('#resultFood3').empty();
	                } else {
	                	alert('음식을 조회 후 등록 버튼을 눌러주세요!');
	                }
	            },
	            error : function(e){
	                alert('[에러]'+e.status);
	            }
	        });
	    });
		
		$( '#btn3' ).button().on( 'click', function() {
			$( '#dialogContainer3' ).dialog( 'open' ); 
		});

		//=========================================================================================================================
	
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
  <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5">
    <a href="/main.do">
      <img src="src/images/logo/logo2.jpg" width="100%" height="100%" />
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
      <!-- Menu Group -->
      <div>
        <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2">메뉴</h3>

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
              <svg
                class="fill-current"
                width="18"
                height="18"
                viewBox="0 0 18 18"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M15.7499 2.9812H14.2874V2.36245C14.2874 2.02495 14.0062 1.71558 13.6405 1.71558C13.2749 1.71558 12.9937 1.99683 12.9937 2.36245V2.9812H4.97803V2.36245C4.97803 2.02495 4.69678 1.71558 4.33115 1.71558C3.96553 1.71558 3.68428 1.99683 3.68428 2.36245V2.9812H2.2499C1.29365 2.9812 0.478027 3.7687 0.478027 4.75308V14.5406C0.478027 15.4968 1.26553 16.3125 2.2499 16.3125H15.7499C16.7062 16.3125 17.5218 15.525 17.5218 14.5406V4.72495C17.5218 3.7687 16.7062 2.9812 15.7499 2.9812ZM1.77178 8.21245H4.1624V10.9968H1.77178V8.21245ZM5.42803 8.21245H8.38115V10.9968H5.42803V8.21245ZM8.38115 12.2625V15.0187H5.42803V12.2625H8.38115ZM9.64678 12.2625H12.5999V15.0187H9.64678V12.2625ZM9.64678 10.9968V8.21245H12.5999V10.9968H9.64678ZM13.8374 8.21245H16.228V10.9968H13.8374V8.21245ZM2.2499 4.24683H3.7124V4.83745C3.7124 5.17495 3.99365 5.48433 4.35928 5.48433C4.7249 5.48433 5.00615 5.20308 5.00615 4.83745V4.24683H13.0499V4.83745C13.0499 5.17495 13.3312 5.48433 13.6968 5.48433C14.0624 5.48433 14.3437 5.20308 14.3437 4.83745V4.24683H15.7499C16.0312 4.24683 16.2562 4.47183 16.2562 4.75308V6.94683H1.77178V4.75308C1.77178 4.47183 1.96865 4.24683 2.2499 4.24683ZM1.77178 14.5125V12.2343H4.1624V14.9906H2.2499C1.96865 15.0187 1.77178 14.7937 1.77178 14.5125ZM15.7499 15.0187H13.8374V12.2625H16.228V14.5406C16.2562 14.7937 16.0312 15.0187 15.7499 15.0187Z"
                  fill=""
                />
              </svg>

              공지사항
            </a>
          </li>
          <!-- Menu Item Calendar -->

          <!-- Menu Item Profile -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="#"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >
              <svg
                class="fill-current"
                width="18"
                height="18"
                viewBox="0 0 18 18"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M9.0002 7.79065C11.0814 7.79065 12.7689 6.1594 12.7689 4.1344C12.7689 2.1094 11.0814 0.478149 9.0002 0.478149C6.91895 0.478149 5.23145 2.1094 5.23145 4.1344C5.23145 6.1594 6.91895 7.79065 9.0002 7.79065ZM9.0002 1.7719C10.3783 1.7719 11.5033 2.84065 11.5033 4.16252C11.5033 5.4844 10.3783 6.55315 9.0002 6.55315C7.62207 6.55315 6.49707 5.4844 6.49707 4.16252C6.49707 2.84065 7.62207 1.7719 9.0002 1.7719Z"
                  fill=""
                />
                <path
                  d="M10.8283 9.05627H7.17207C4.16269 9.05627 1.71582 11.5313 1.71582 14.5406V16.875C1.71582 17.2125 1.99707 17.5219 2.3627 17.5219C2.72832 17.5219 3.00957 17.2407 3.00957 16.875V14.5406C3.00957 12.2344 4.89394 10.3219 7.22832 10.3219H10.8564C13.1627 10.3219 15.0752 12.2063 15.0752 14.5406V16.875C15.0752 17.2125 15.3564 17.5219 15.7221 17.5219C16.0877 17.5219 16.3689 17.2407 16.3689 16.875V14.5406C16.2846 11.5313 13.8377 9.05627 10.8283 9.05627Z"
                  fill=""
                />
              </svg>

             	게시판
            </a>
          </li>
          <!-- Menu Item Profile -->
          
              <!-- Menu Item Profile2 -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="food.do"
              @click="selected = (selected === 'food' ? '':'food')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'food') && (page === 'food') }"
              :class="page === 'food' && 'bg-graydark'"
            >
              <svg
                class="fill-current"
                width="18"
                height="18"
                viewBox="0 0 18 18"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M9.0002 7.79065C11.0814 7.79065 12.7689 6.1594 12.7689 4.1344C12.7689 2.1094 11.0814 0.478149 9.0002 0.478149C6.91895 0.478149 5.23145 2.1094 5.23145 4.1344C5.23145 6.1594 6.91895 7.79065 9.0002 7.79065ZM9.0002 1.7719C10.3783 1.7719 11.5033 2.84065 11.5033 4.16252C11.5033 5.4844 10.3783 6.55315 9.0002 6.55315C7.62207 6.55315 6.49707 5.4844 6.49707 4.16252C6.49707 2.84065 7.62207 1.7719 9.0002 1.7719Z"
                  fill=""
                />
                <path
                  d="M10.8283 9.05627H7.17207C4.16269 9.05627 1.71582 11.5313 1.71582 14.5406V16.875C1.71582 17.2125 1.99707 17.5219 2.3627 17.5219C2.72832 17.5219 3.00957 17.2407 3.00957 16.875V14.5406C3.00957 12.2344 4.89394 10.3219 7.22832 10.3219H10.8564C13.1627 10.3219 15.0752 12.2063 15.0752 14.5406V16.875C15.0752 17.2125 15.3564 17.5219 15.7221 17.5219C16.0877 17.5219 16.3689 17.2407 16.3689 16.875V14.5406C16.2846 11.5313 13.8377 9.05627 10.8283 9.05627Z"
                  fill=""
                />
              </svg>

             	식단
            </a>
          </li>
          <!-- Menu Item Profile2 -->

          <!-- Menu Item Forms -->

          <!-- Menu Item Tables -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="tables.do"
              @click="selected = (selected === 'Tables' ? '':'Tables')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Tables') && (page === 'Tables') }"
            >
              <svg
                class="fill-current"
                width="18"
                height="19"
                viewBox="0 0 18 19"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g clip-path="url(#clip0_130_9756)">
                  <path
                    d="M15.7501 0.55835H2.2501C1.29385 0.55835 0.506348 1.34585 0.506348 2.3021V15.8021C0.506348 16.7584 1.29385 17.574 2.27822 17.574H15.7782C16.7345 17.574 17.5501 16.7865 17.5501 15.8021V2.3021C17.522 1.34585 16.7063 0.55835 15.7501 0.55835ZM6.69385 10.599V6.4646H11.3063V10.5709H6.69385V10.599ZM11.3063 11.8646V16.3083H6.69385V11.8646H11.3063ZM1.77197 6.4646H5.45635V10.5709H1.77197V6.4646ZM12.572 6.4646H16.2563V10.5709H12.572V6.4646ZM2.2501 1.82397H15.7501C16.0313 1.82397 16.2563 2.04897 16.2563 2.33022V5.2271H1.77197V2.3021C1.77197 2.02085 1.96885 1.82397 2.2501 1.82397ZM1.77197 15.8021V11.8646H5.45635V16.3083H2.2501C1.96885 16.3083 1.77197 16.0834 1.77197 15.8021ZM15.7501 16.3083H12.572V11.8646H16.2563V15.8021C16.2563 16.0834 16.0313 16.3083 15.7501 16.3083Z"
                    fill=""
                  />
                </g>
                <defs>
                  <clipPath id="clip0_130_9756">
                    <rect
                      width="18"
                      height="18"
                      fill="white"
                      transform="translate(0 0.052124)"
                    />
                  </clipPath>
                </defs>
              </svg>

              운동
            </a>
          </li>
          <!-- Menu Item Tables -->
		  <br/><br/>
          <!-- Menu Item Settings -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="settings.do"
              @click="selected = (selected === 'Settings' ? '':'Settings')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Settings') && (page === 'settings') }"
              :class="page === 'settings' && 'bg-graydark'"
            >
              <svg
                class="fill-current"
                width="18"
                height="19"
                viewBox="0 0 18 19"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g clip-path="url(#clip0_130_9763)">
                  <path
                    d="M17.0721 7.30835C16.7909 6.99897 16.3971 6.83022 15.9752 6.83022H15.8909C15.7502 6.83022 15.6377 6.74585 15.6096 6.63335C15.5815 6.52085 15.5252 6.43647 15.4971 6.32397C15.4409 6.21147 15.4971 6.09897 15.5815 6.0146L15.6377 5.95835C15.9471 5.6771 16.1159 5.28335 16.1159 4.86147C16.1159 4.4396 15.9752 4.04585 15.6659 3.73647L14.569 2.61147C13.9784 1.99272 12.9659 1.9646 12.3471 2.58335L12.2627 2.6396C12.1784 2.72397 12.0377 2.7521 11.8971 2.69585C11.7846 2.6396 11.6721 2.58335 11.5315 2.55522C11.3909 2.49897 11.3065 2.38647 11.3065 2.27397V2.13335C11.3065 1.26147 10.6034 0.55835 9.73148 0.55835H8.15648C7.7346 0.55835 7.34085 0.7271 7.0596 1.00835C6.75023 1.31772 6.6096 1.71147 6.6096 2.10522V2.21772C6.6096 2.33022 6.52523 2.44272 6.41273 2.49897C6.35648 2.5271 6.32835 2.5271 6.2721 2.55522C6.1596 2.61147 6.01898 2.58335 5.9346 2.49897L5.87835 2.4146C5.5971 2.10522 5.20335 1.93647 4.78148 1.93647C4.3596 1.93647 3.96585 2.0771 3.65648 2.38647L2.53148 3.48335C1.91273 4.07397 1.8846 5.08647 2.50335 5.70522L2.5596 5.7896C2.64398 5.87397 2.6721 6.0146 2.61585 6.09897C2.5596 6.21147 2.53148 6.29585 2.47523 6.40835C2.41898 6.52085 2.3346 6.5771 2.19398 6.5771H2.1096C1.68773 6.5771 1.29398 6.71772 0.984604 7.0271C0.675229 7.30835 0.506479 7.7021 0.506479 8.12397L0.478354 9.69897C0.450229 10.5708 1.15335 11.274 2.02523 11.3021H2.1096C2.25023 11.3021 2.36273 11.3865 2.39085 11.499C2.4471 11.5833 2.50335 11.6677 2.53148 11.7802C2.5596 11.8927 2.53148 12.0052 2.4471 12.0896L2.39085 12.1458C2.08148 12.4271 1.91273 12.8208 1.91273 13.2427C1.91273 13.6646 2.05335 14.0583 2.36273 14.3677L3.4596 15.4927C4.05023 16.1115 5.06273 16.1396 5.68148 15.5208L5.76585 15.4646C5.85023 15.3802 5.99085 15.3521 6.13148 15.4083C6.24398 15.4646 6.35648 15.5208 6.4971 15.549C6.63773 15.6052 6.7221 15.7177 6.7221 15.8302V15.9427C6.7221 16.8146 7.42523 17.5177 8.2971 17.5177H9.8721C10.744 17.5177 11.4471 16.8146 11.4471 15.9427V15.8302C11.4471 15.7177 11.5315 15.6052 11.644 15.549C11.7002 15.5208 11.7284 15.5208 11.7846 15.4927C11.9252 15.4365 12.0377 15.4646 12.1221 15.549L12.1784 15.6333C12.4596 15.9427 12.8534 16.1115 13.2752 16.1115C13.6971 16.1115 14.0909 15.9708 14.4002 15.6615L15.5252 14.5646C16.144 13.974 16.1721 12.9615 15.5534 12.3427L15.4971 12.2583C15.4127 12.174 15.3846 12.0333 15.4409 11.949C15.4971 11.8365 15.5252 11.7521 15.5815 11.6396C15.6377 11.5271 15.7502 11.4708 15.8627 11.4708H15.9471H15.9752C16.819 11.4708 17.5221 10.7958 17.5502 9.92397L17.5784 8.34897C17.5221 8.01147 17.3534 7.5896 17.0721 7.30835ZM16.2284 9.9521C16.2284 10.1208 16.0877 10.2615 15.919 10.2615H15.8346H15.8065C15.1596 10.2615 14.569 10.6552 14.344 11.2177C14.3159 11.3021 14.2596 11.3865 14.2315 11.4708C13.9784 12.0333 14.0909 12.7365 14.5409 13.1865L14.5971 13.2708C14.7096 13.3833 14.7096 13.5802 14.5971 13.6927L13.4721 14.7896C13.3877 14.874 13.3034 14.874 13.2471 14.874C13.1909 14.874 13.1065 14.874 13.0221 14.7896L12.9659 14.7052C12.5159 14.2271 11.8409 14.0865 11.2221 14.3677L11.1096 14.424C10.4909 14.6771 10.0971 15.2396 10.0971 15.8865V15.999C10.0971 16.1677 9.95648 16.3083 9.78773 16.3083H8.21273C8.04398 16.3083 7.90335 16.1677 7.90335 15.999V15.8865C7.90335 15.2396 7.5096 14.649 6.89085 14.424C6.80648 14.3958 6.69398 14.3396 6.6096 14.3115C6.3846 14.199 6.1596 14.1708 5.9346 14.1708C5.54085 14.1708 5.1471 14.3115 4.83773 14.6208L4.78148 14.649C4.66898 14.7615 4.4721 14.7615 4.3596 14.649L3.26273 13.524C3.17835 13.4396 3.17835 13.3552 3.17835 13.299C3.17835 13.2427 3.17835 13.1583 3.26273 13.074L3.31898 13.0177C3.7971 12.5677 3.93773 11.8646 3.6846 11.3021C3.65648 11.2177 3.62835 11.1333 3.5721 11.049C3.3471 10.4583 2.7846 10.0365 2.13773 10.0365H2.05335C1.8846 10.0365 1.74398 9.89585 1.74398 9.7271L1.7721 8.1521C1.7721 8.0396 1.82835 7.98335 1.85648 7.9271C1.8846 7.89897 1.96898 7.84272 2.08148 7.84272H2.16585C2.81273 7.87085 3.40335 7.4771 3.65648 6.88647C3.6846 6.8021 3.74085 6.71772 3.76898 6.63335C4.0221 6.07085 3.9096 5.36772 3.4596 4.91772L3.40335 4.83335C3.29085 4.72085 3.29085 4.52397 3.40335 4.41147L4.52835 3.3146C4.61273 3.23022 4.6971 3.23022 4.75335 3.23022C4.8096 3.23022 4.89398 3.23022 4.97835 3.3146L5.0346 3.39897C5.4846 3.8771 6.1596 4.01772 6.77835 3.7646L6.89085 3.70835C7.5096 3.45522 7.90335 2.89272 7.90335 2.24585V2.13335C7.90335 2.02085 7.9596 1.9646 7.98773 1.90835C8.01585 1.8521 8.10023 1.82397 8.21273 1.82397H9.78773C9.95648 1.82397 10.0971 1.9646 10.0971 2.13335V2.24585C10.0971 2.89272 10.4909 3.48335 11.1096 3.70835C11.194 3.73647 11.3065 3.79272 11.3909 3.82085C11.9815 4.1021 12.6846 3.9896 13.1627 3.5396L13.2471 3.48335C13.3596 3.37085 13.5565 3.37085 13.669 3.48335L14.7659 4.60835C14.8502 4.69272 14.8502 4.7771 14.8502 4.83335C14.8502 4.8896 14.8221 4.97397 14.7659 5.05835L14.7096 5.1146C14.2034 5.53647 14.0627 6.2396 14.2877 6.8021C14.3159 6.88647 14.344 6.97085 14.4002 7.05522C14.6252 7.64585 15.1877 8.06772 15.8346 8.06772H15.919C16.0315 8.06772 16.0877 8.12397 16.144 8.1521C16.2002 8.18022 16.2284 8.2646 16.2284 8.3771V9.9521Z"
                    fill=""
                  />
                  <path
                    d="M9.00029 5.22705C6.89092 5.22705 5.17529 6.94268 5.17529 9.05205C5.17529 11.1614 6.89092 12.8771 9.00029 12.8771C11.1097 12.8771 12.8253 11.1614 12.8253 9.05205C12.8253 6.94268 11.1097 5.22705 9.00029 5.22705ZM9.00029 11.6114C7.59404 11.6114 6.44092 10.4583 6.44092 9.05205C6.44092 7.6458 7.59404 6.49268 9.00029 6.49268C10.4065 6.49268 11.5597 7.6458 11.5597 9.05205C11.5597 10.4583 10.4065 11.6114 9.00029 11.6114Z"
                    fill=""
                  />
                </g>
                <defs>
                  <clipPath id="clip0_130_9763">
                    <rect
                      width="18"
                      height="18"
                      fill="white"
                      transform="translate(0 0.052124)"
                    />
                  </clipPath>
                </defs>
              </svg>

            	로그아웃
            </a>
          </li>
        </ul>
      </div>
  </div>
</aside>

    <!-- ===== Sidebar End ===== -->

    <!-- ===== Content Area Start ===== -->
    <div class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
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
      <a class="block flex-shrink-0 lg:hidden" href="index.html">
        <img src="src/images/logo/logo-icon.svg" alt="Logo" />
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
              >Thomas Anree</span
            >
            <span class="block text-xs font-medium">UX Designer</span>
          </span>

          <span class="h-12 w-12 rounded-full">
            <img src="src/images/user/user-01.png" alt="User" />
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
                href="profile.html"
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
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
                My Profile
              </a>
            </li>
            <li>
              <a
                href="#"
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
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
                    d="M17.6687 1.44374C17.1187 0.893744 16.4312 0.618744 15.675 0.618744H7.42498C6.25623 0.618744 5.25935 1.58124 5.25935 2.78437V4.12499H4.29685C3.88435 4.12499 3.50623 4.46874 3.50623 4.91562C3.50623 5.36249 3.84998 5.70624 4.29685 5.70624H5.25935V10.2781H4.29685C3.88435 10.2781 3.50623 10.6219 3.50623 11.0687C3.50623 11.4812 3.84998 11.8594 4.29685 11.8594H5.25935V16.4312H4.29685C3.88435 16.4312 3.50623 16.775 3.50623 17.2219C3.50623 17.6687 3.84998 18.0125 4.29685 18.0125H5.25935V19.25C5.25935 20.4187 6.22185 21.4156 7.42498 21.4156H15.675C17.2218 21.4156 18.4937 20.1437 18.5281 18.5969V3.47187C18.4937 2.68124 18.2187 1.95937 17.6687 1.44374ZM16.9469 18.5625C16.9469 19.2844 16.3625 19.8344 15.6406 19.8344H7.3906C7.04685 19.8344 6.77185 19.5594 6.77185 19.2156V17.875H8.6281C9.0406 17.875 9.41873 17.5312 9.41873 17.0844C9.41873 16.6375 9.07498 16.2937 8.6281 16.2937H6.77185V11.7906H8.6281C9.0406 11.7906 9.41873 11.4469 9.41873 11C9.41873 10.5875 9.07498 10.2094 8.6281 10.2094H6.77185V5.63749H8.6281C9.0406 5.63749 9.41873 5.29374 9.41873 4.84687C9.41873 4.39999 9.07498 4.05624 8.6281 4.05624H6.77185V2.74999C6.77185 2.40624 7.04685 2.13124 7.3906 2.13124H15.6406C15.9844 2.13124 16.2937 2.26874 16.5687 2.50937C16.8094 2.74999 16.9469 3.09374 16.9469 3.43749V18.5625Z"
                    fill=""
                  />
                </svg>
                My Contacts
              </a>
            </li>
            <li>
              <a
                href="settings.html"
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
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
                    d="M20.8656 8.86874C20.5219 8.49062 20.0406 8.28437 19.525 8.28437H19.4219C19.25 8.28437 19.1125 8.18124 19.0781 8.04374C19.0437 7.90624 18.975 7.80312 18.9406 7.66562C18.8719 7.52812 18.9406 7.39062 19.0437 7.28749L19.1125 7.21874C19.4906 6.87499 19.6969 6.39374 19.6969 5.87812C19.6969 5.36249 19.525 4.88124 19.1469 4.50312L17.8062 3.12812C17.0844 2.37187 15.8469 2.33749 15.0906 3.09374L14.9875 3.16249C14.8844 3.26562 14.7125 3.29999 14.5406 3.23124C14.4031 3.16249 14.2656 3.09374 14.0937 3.05937C13.9219 2.99062 13.8187 2.85312 13.8187 2.71562V2.54374C13.8187 1.47812 12.9594 0.618744 11.8937 0.618744H9.96875C9.45312 0.618744 8.97187 0.824994 8.62812 1.16874C8.25 1.54687 8.07812 2.02812 8.07812 2.50937V2.64687C8.07812 2.78437 7.975 2.92187 7.8375 2.99062C7.76875 3.02499 7.73437 3.02499 7.66562 3.05937C7.52812 3.12812 7.35625 3.09374 7.25312 2.99062L7.18437 2.88749C6.84062 2.50937 6.35937 2.30312 5.84375 2.30312C5.32812 2.30312 4.84687 2.47499 4.46875 2.85312L3.09375 4.19374C2.3375 4.91562 2.30312 6.15312 3.05937 6.90937L3.12812 7.01249C3.23125 7.11562 3.26562 7.28749 3.19687 7.39062C3.12812 7.52812 3.09375 7.63124 3.025 7.76874C2.95625 7.90624 2.85312 7.97499 2.68125 7.97499H2.57812C2.0625 7.97499 1.58125 8.14687 1.20312 8.52499C0.824996 8.86874 0.618746 9.34999 0.618746 9.86562L0.584371 11.7906C0.549996 12.8562 1.40937 13.7156 2.475 13.75H2.57812C2.75 13.75 2.8875 13.8531 2.92187 13.9906C2.99062 14.0937 3.05937 14.1969 3.09375 14.3344C3.12812 14.4719 3.09375 14.6094 2.99062 14.7125L2.92187 14.7812C2.54375 15.125 2.3375 15.6062 2.3375 16.1219C2.3375 16.6375 2.50937 17.1187 2.8875 17.4969L4.22812 18.8719C4.95 19.6281 6.1875 19.6625 6.94375 18.9062L7.04687 18.8375C7.15 18.7344 7.32187 18.7 7.49375 18.7687C7.63125 18.8375 7.76875 18.9062 7.94062 18.9406C8.1125 19.0094 8.21562 19.1469 8.21562 19.2844V19.4219C8.21562 20.4875 9.075 21.3469 10.1406 21.3469H12.0656C13.1312 21.3469 13.9906 20.4875 13.9906 19.4219V19.2844C13.9906 19.1469 14.0937 19.0094 14.2312 18.9406C14.3 18.9062 14.3344 18.9062 14.4031 18.8719C14.575 18.8031 14.7125 18.8375 14.8156 18.9406L14.8844 19.0437C15.2281 19.4219 15.7094 19.6281 16.225 19.6281C16.7406 19.6281 17.2219 19.4562 17.6 19.0781L18.975 17.7375C19.7312 17.0156 19.7656 15.7781 19.0094 15.0219L18.9406 14.9187C18.8375 14.8156 18.8031 14.6437 18.8719 14.5406C18.9406 14.4031 18.975 14.3 19.0437 14.1625C19.1125 14.025 19.25 13.9562 19.3875 13.9562H19.4906H19.525C20.5562 13.9562 21.4156 13.1312 21.45 12.0656L21.4844 10.1406C21.4156 9.72812 21.2094 9.21249 20.8656 8.86874ZM19.8344 12.1C19.8344 12.3062 19.6625 12.4781 19.4562 12.4781H19.3531H19.3187C18.5281 12.4781 17.8062 12.9594 17.5312 13.6469C17.4969 13.75 17.4281 13.8531 17.3937 13.9562C17.0844 14.6437 17.2219 15.5031 17.7719 16.0531L17.8406 16.1562C17.9781 16.2937 17.9781 16.5344 17.8406 16.6719L16.4656 18.0125C16.3625 18.1156 16.2594 18.1156 16.1906 18.1156C16.1219 18.1156 16.0187 18.1156 15.9156 18.0125L15.8469 17.9094C15.2969 17.325 14.4719 17.1531 13.7156 17.4969L13.5781 17.5656C12.8219 17.875 12.3406 18.5625 12.3406 19.3531V19.4906C12.3406 19.6969 12.1687 19.8687 11.9625 19.8687H10.0375C9.83125 19.8687 9.65937 19.6969 9.65937 19.4906V19.3531C9.65937 18.5625 9.17812 17.8406 8.42187 17.5656C8.31875 17.5312 8.18125 17.4625 8.07812 17.4281C7.80312 17.2906 7.52812 17.2562 7.25312 17.2562C6.77187 17.2562 6.29062 17.4281 5.9125 17.8062L5.84375 17.8406C5.70625 17.9781 5.46562 17.9781 5.32812 17.8406L3.9875 16.4656C3.88437 16.3625 3.88437 16.2594 3.88437 16.1906C3.88437 16.1219 3.88437 16.0187 3.9875 15.9156L4.05625 15.8469C4.64062 15.2969 4.8125 14.4375 4.50312 13.75C4.46875 13.6469 4.43437 13.5437 4.36562 13.4406C4.09062 12.7187 3.40312 12.2031 2.6125 12.2031H2.50937C2.30312 12.2031 2.13125 12.0312 2.13125 11.825L2.16562 9.89999C2.16562 9.76249 2.23437 9.69374 2.26875 9.62499C2.30312 9.59062 2.40625 9.52187 2.54375 9.52187H2.64687C3.4375 9.55624 4.15937 9.07499 4.46875 8.35312C4.50312 8.24999 4.57187 8.14687 4.60625 8.04374C4.91562 7.35624 4.77812 6.49687 4.22812 5.94687L4.15937 5.84374C4.02187 5.70624 4.02187 5.46562 4.15937 5.32812L5.53437 3.98749C5.6375 3.88437 5.74062 3.88437 5.80937 3.88437C5.87812 3.88437 5.98125 3.88437 6.08437 3.98749L6.15312 4.09062C6.70312 4.67499 7.52812 4.84687 8.28437 4.53749L8.42187 4.46874C9.17812 4.15937 9.65937 3.47187 9.65937 2.68124V2.54374C9.65937 2.40624 9.72812 2.33749 9.7625 2.26874C9.79687 2.19999 9.9 2.16562 10.0375 2.16562H11.9625C12.1687 2.16562 12.3406 2.33749 12.3406 2.54374V2.68124C12.3406 3.47187 12.8219 4.19374 13.5781 4.46874C13.6812 4.50312 13.8187 4.57187 13.9219 4.60624C14.6437 4.94999 15.5031 4.81249 16.0875 4.26249L16.1906 4.19374C16.3281 4.05624 16.5687 4.05624 16.7062 4.19374L18.0469 5.56874C18.15 5.67187 18.15 5.77499 18.15 5.84374C18.15 5.91249 18.1156 6.01562 18.0469 6.11874L17.9781 6.18749C17.3594 6.70312 17.1875 7.56249 17.4625 8.24999C17.4969 8.35312 17.5312 8.45624 17.6 8.55937C17.875 9.28124 18.5625 9.79687 19.3531 9.79687H19.4562C19.5937 9.79687 19.6625 9.86562 19.7312 9.89999C19.8 9.93437 19.8344 10.0375 19.8344 10.175V12.1Z"
                    fill=""
                  />
                  <path
                    d="M11 6.32498C8.42189 6.32498 6.32501 8.42186 6.32501 11C6.32501 13.5781 8.42189 15.675 11 15.675C13.5781 15.675 15.675 13.5781 15.675 11C15.675 8.42186 13.5781 6.32498 11 6.32498ZM11 14.1281C9.28126 14.1281 7.87189 12.7187 7.87189 11C7.87189 9.28123 9.28126 7.87186 11 7.87186C12.7188 7.87186 14.1281 9.28123 14.1281 11C14.1281 12.7187 12.7188 14.1281 11 14.1281Z"
                    fill=""
                  />
                </svg>
                Account Settings
              </a>
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
            <a href="/logout">로그아웃</a>
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
			<h4 class="text-title-md2 font-bold text-black dark:text-white" style="padding-left: 30px">
			    식단 메모
			</h4>
		</div>
        <!-- =============================== 타이틀 끝 ========================= -->

        <hr style="padding-bottom: 30px"/>

        <!-- =============================== 아침 ========================= -->
          	
        <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark" >
        	<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
				<div class="flex items-center">
			   		<h4 class="font-medium text-black dark:text-white mr-4">
			    		아침
			    	</h4>
			    	<button id="btn1">
			    		<img src="https://m.ftscrt.com/static/images/foodadd/FA_add.png" width="17px" height="17px">
			    	</button>
			    	<div style="display: flex; flex-direction: row;">
						<button id="fbtn1" style="padding-left: 30px;">등록</buttoN>
					</div>
			    	<div id="dialogContainer1" title="검색">
						<input type="text" id="foodName1" placeholder="검색어를 입력하세요">
						<button id="searchButton1">검색</button>
						<div id="foodComent1"></div>
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
<!--            	<label class="mb-3 block font-medium text-sm text-black dark:text-white"> -->
					<!-- Default Input -->
<!--                </label> -->
		            <form action="#" method="post" name="ffrm">
						<input type="hidden" name="seq" id="seq" value="${seq}" />
						<div id="resultFood1"></div>
					</form>
	        	</div>
        	</div>
        </div>
        </div> 
        <!-- =============================== 아침 끝 =========================== -->
        
        <!-- =============================== 점심 시작 =========================== -->
        
        <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">

        <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark" >
        	<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
				<div class="flex items-center">
			   		<h4 class="font-medium text-black dark:text-white mr-4">
			    		점심
			    	</h4>
			    	<button id="btn2">
			    		<img src="https://m.ftscrt.com/static/images/foodadd/FA_add.png" width="17px" height="17px">
			    	</button>
			    	<div style="display: flex; flex-direction: row;">
						<button id="fbtn2" style="padding-left: 30px;">등록</buttoN>
					</div>
			    	<div id="dialogContainer2" title="검색">
						<input type="text" id="foodName2" placeholder="검색어를 입력하세요">
						<button id="searchButton2">검색</button>
						<div id="foodComent2"></div>
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
						<div id="resultFood2"></div>
					</form>
	        	</div>
        	</div>
        </div>
        
        </div>
        
        <!-- =============================== 점심 끝 =========================== -->

        <!-- =============================== 저녁 시작 =========================== -->
        
        <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">

        <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark" >
        	<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
				<div class="flex items-center">
			   		<h4 class="font-medium text-black dark:text-white mr-4">
			    		저녁
			    	</h4>
			    	<button id="btn3">
			    		<img src="https://m.ftscrt.com/static/images/foodadd/FA_add.png" width="17px" height="17px">
			    	</button>
			    	<div style="display: flex; flex-direction: row;">
						<button id="fbtn3" style="padding-left: 30px;">등록</buttoN>
					</div>
			    	<div id="dialogContainer3" title="검색">
						<input type="text" id="foodName3" placeholder="검색어를 입력하세요">
						<button id="searchButton3">검색</button>
						<div id="foodComent3"></div>
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
						<div id="resultFood3"></div>
					</form>
	        	</div>
        	</div>
        </div>
        
        </div>
        
        
        <!-- =============================== 저녁 끝 =========================== -->
        
        <!-- =============================== div 끝 =========================== -->
	  </main> 
      <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
  </div>
  <!-- ===== Page Wrapper End ===== -->
<script defer src="bundle.js"></script></body>

</html>