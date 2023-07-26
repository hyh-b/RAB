$(document).ready(function() {
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
        
         
         //const editorData = editor.getData();
         
        //console.log(' editorData? ->', editor.getData());
        
        // feedback ajax요청
        if (f_subject.trim() === "" || f_content.trim() === "") {
             swal({
                  title: "제목과 내용은 필수입니다!",
                  text: "제목과 내용을 입력해주세요!",
                  icon: "warning",
                  button: "확인",            
              });
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

                    swal({
	                  title: "소중한 피드백 감사합니다!",
	                  text: "여러분의 피드백을 바탕으로 사이트 개선에 힘쓰겠습니다.",
	                  icon: "success",
	                  button: "확인",            
             		 });
                    document.querySelector(".chatbot-dialog").style.display = "none";
                    resetForm();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log("HTTP Status: " + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
                    console.log("Throw Error: " + errorThrown); // 예외 정보
                    console.log("jqXHR Object: " + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
                     swal({
	                  title: "X",
	                  text: "업데이트에 실패했습니다!",
	                  icon: "error",
	                  button: "확인",            
             		 });
                },
            });
        }
    });

    //클립보드 f_content에 붙혀서 가지고 오기, 파일업로드로 변경해야할듯?
    document.querySelector('#f_content').addEventListener('paste', function (event) {
        var clipboardData = event.clipboardData || window.clipboardData;
        var pastedText = clipboardData.getData('text');
        
        // Prevent the default paste behavior
        event.preventDefault();
        
        // Set the pasted text to f_content input
        this.value = pastedText;
    });
  
    document.querySelector("#f_name").value = $("#zzinname").val();
    document.querySelector("#f_id").value = $("#zzinid").val();
    document.querySelector("#f_mail").value = $("#zzinmail").val();
    
    //제목, 콘텐츠 입력칸 초기화
    function resetForm() {
        document.querySelector("#f_subject").value = "";
        document.querySelector("#f_content").value = "";
    }
    //ckeditor 설정
    //------------------------------------------------------------------------------
	
		
		
		
		   	//// 
});