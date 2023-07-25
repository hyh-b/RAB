package com.example.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.BoardDAO;
import com.example.model.BoardListTO;
import com.example.model.BoardTO;
import com.example.model.CommentDAO;
import com.example.model.CommentTO;
import com.example.security.CustomUserDetails;
import com.example.upload.S3FileUploadService;

@RestController
public class BoardController {

	@Autowired
	BoardDAO boardDAO;
	
	@Autowired
	CommentDAO commentDAO;
	
	// 프로퍼티에서 버킷 이름 할당
		@Value("${cloud.aws.s3.bucket}")
		private String bucket;
		
		//프로퍼티에서 지역 코드 할당
		@Value("${cloud.aws.region.static}")
		private String region;
		
		private final S3FileUploadService s3FileUploadService;
		// 업로드 시 db에 저장되는 url중 고정 부분
		String base = "https://s3.ap-northeast-2.amazonaws.com/rabfile/";
		
		public BoardController(S3FileUploadService s3FileUploadService) {
	        this.s3FileUploadService = s3FileUploadService;
	    }
		
// 리스트 ===================================================================================================
		@RequestMapping("/board_list1.do") 
		public ModelAndView boardList( HttpServletRequest request, Authentication authentication) {
			
			BoardTO to1 = new BoardTO();
			Object principal = authentication.getPrincipal();
			CustomUserDetails customUserDetails = (CustomUserDetails) principal;
			String name = customUserDetails.getM_name();
			String profilename = customUserDetails.getM_profilename();
			
			int cpage = 1;
			if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
				cpage = Integer.parseInt(request.getParameter("cpage"));
			}
			
			BoardListTO listTo = new BoardListTO();
			listTo.setCpage(cpage);
			
			// boardList
			ArrayList<BoardTO> boardLists = boardDAO.boardList(listTo);
			StringBuilder sbHTML = new StringBuilder();
			int count = 0; 
			
			for (BoardTO to : boardLists) {
				
				String seq = to.getU_seq();
				String subject = to.getU_subject();
				String writer = to.getU_writer();
				long filesize = to.getU_filesize();
				String filename = to.getU_filename();
				String wdate = to.getU_wdate();
				int hit = to.getU_hit();
				int wgap = to.getWgap();
				
				// 답글 수
				int cmt = to.getU_commentcount();
//				System.out.println("list.jsp getcommentcount() >>> " + to.getU_commentcount() );
				
			    if (count % 5 == 0) {
			        // 5번째 <tr> 요소인 경우 현재 행을 닫고 새로운 행을 시작
			        if (count > 0) {
			            sbHTML.append("</tr>");
			        }

			        sbHTML.append("<tr>"); // 5번째 요소마다 새로운 행 시작
			    }
			    sbHTML.append("<td width='20%' class='last2'>");
			    sbHTML.append("<div class='board'>");
			    sbHTML.append("<table class='boardT'>");
			    sbHTML.append("<tr>");
			    sbHTML.append("<td class='boardThumbWrap'>");
			    sbHTML.append("<div class='boardThumb'>");
			    sbHTML.append("<a href='board_view1.do?seq=" + seq + "&&cpage="+cpage+"'><img src='https://rabfile.s3.ap-northeast-2.amazonaws.com/"+filename+"' border='0' width='100%' /></a>");
			    sbHTML.append("</div>");
			    sbHTML.append("</td>");
			    sbHTML.append("</tr>");
			    sbHTML.append("<tr>");
			    sbHTML.append("<td>");
			    sbHTML.append("<div class='boardItem'>");
			    sbHTML.append("<strong>" + subject + "</strong>");
			    
			    // 코멘트
			    sbHTML.append("<span class='coment_number'><img src='./images/icon_comment.png' alt='commnet'>"+cmt+"</span>");
			    
			    if (wgap == 0) {
			    	sbHTML.append("<img src='./images/icon_new.gif' alt='NEW'>");
			    }
			    sbHTML.append("</div>");
			    sbHTML.append("</td>");
			    sbHTML.append("</tr>");
			    sbHTML.append("<tr>");
			    sbHTML.append("<td><div class='boardItem'><span class='bold_blue'>" + writer + "</span></div></td>");
			    sbHTML.append("</tr>");
			    sbHTML.append("<tr>");
			    sbHTML.append("<td><div class='boardItem'> " + wdate + " <font>|</font> Hit " + hit + "</div></td>");
			    sbHTML.append("</tr>");
			    sbHTML.append("</table>");
			    sbHTML.append("</div>");
			    sbHTML.append("</td>");

				 count++;
			}
			
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("board_list1");
			
			// 데이터 넘겨주기
			modelAndView.addObject("boardLists" , boardLists );
			modelAndView.addObject("listTo" , listTo );
			modelAndView.addObject("sbHTML" , sbHTML );
			modelAndView.addObject("profilename" , profilename );
			modelAndView.addObject("name" , name );
			
			return modelAndView;
		}

// 뷰 ==========================================================================
		@RequestMapping("/board_view1.do") 
		public ModelAndView boardView( HttpServletRequest request, Authentication authentication) {
		
			// TO & DAO 호출
			BoardTO to = new BoardTO();
			
			to.setU_seq(request.getParameter("seq") );
			
			// m_seq
			Object principal = authentication.getPrincipal();
			CustomUserDetails customUserDetails = (CustomUserDetails) principal;
			String seq = customUserDetails.getM_seq();
			String name = customUserDetails.getM_name();
			String profilename = customUserDetails.getM_profilename();
			to.setM_seq(seq);
			System.out.println("view to2    " + to);
			BoardListTO listTo = new BoardListTO();
			
			listTo.setCpage( Integer.parseInt(request.getParameter("cpage" ) ) );
			
			to = boardDAO.boardView(to);
			
			// 답글 리스트
			ArrayList<CommentTO> comments = commentDAO.commentList(to);
		
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("board_view1");
			
			// 데이터 넘겨주기
			modelAndView.addObject("to" , to );
			modelAndView.addObject("listTo" , listTo );
			modelAndView.addObject("comments" , comments );
			modelAndView.addObject("name" , name );
			modelAndView.addObject("profilename" , profilename );
			
			return modelAndView;
		}
		
		@RequestMapping("/board_comment_ok1.do") 
		public ModelAndView boardCommentOK( HttpServletRequest request, Authentication authentication) {
			ModelAndView modelAndView = new ModelAndView();
			
			BoardTO to = new BoardTO();
			to.setU_seq(request.getParameter("seq") );
			
			//seq
			Object principal = authentication.getPrincipal();
			CustomUserDetails customUserDetails = (CustomUserDetails) principal;
			String Mseq = customUserDetails.getM_seq();
			to.setM_seq(Mseq);
			
			BoardListTO listTo = new BoardListTO();
			listTo.setCpage( Integer.parseInt(request.getParameter("cpage" ) ) );
//			System.out.println("답글 cpage :     " + Integer.parseInt(request.getParameter("cpage" ) ) );
			
			// 답글 쓰기
			CommentTO Cto = new CommentTO();
			Cto.setM_seq(Mseq);
			Cto.setUc_writer(request.getParameter("cwriter") );
//			System.out.println("답글 쓰기 작성자 : " + request.getParameter("cwriter") );
					
			Cto.setUc_content( request.getParameter("ccontent") );
			System.out.println("답글 쓰기 내용 : " + request.getParameter("ccontent") );
			
			Cto.setU_seq(request.getParameter("seq") );
					
			int flag = commentDAO.CommentOk(Cto);
			System.out.println("답글 flag       " + flag );
				
			modelAndView.setViewName("board_comment_ok1");
				
			// 데이터 넘겨주기
			modelAndView.addObject( "to" , to );
			modelAndView.addObject( "flag" , flag );
			modelAndView.addObject("listTo" , listTo );
			return modelAndView;
		}
		
// 쓰기 ======================================================================
		@RequestMapping("/board_write1.do") 
		public ModelAndView boardWrite( HttpServletRequest request, Authentication authentication) {
			Object principal = authentication.getPrincipal();
			CustomUserDetails customUserDetails = (CustomUserDetails) principal;
			String name = customUserDetails.getM_name();
			String profilename = customUserDetails.getM_profilename();
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("board_write1");
			modelAndView.addObject( "name" , name );
			modelAndView.addObject("profilename" , profilename );
			return modelAndView;
		}

		@RequestMapping("/board_write_ok1.do") 
		public ModelAndView boardWriteOK( HttpServletRequest request, Authentication authentication,
				@RequestParam("upload") MultipartFile upload) throws Exception {
			ModelAndView modelAndView = new ModelAndView();
			
				BoardTO to = new BoardTO();
				to.setU_seq(request.getParameter("seq") );
				to.setU_subject( request.getParameter("subject") );
				to.setU_writer( request.getParameter("writer") );
				
				Object principal = authentication.getPrincipal();
				CustomUserDetails customUserDetails = (CustomUserDetails) principal;
				String seq = customUserDetails.getM_seq();
				to.setM_seq(seq);
				
				to.setU_content( request.getParameter("content") );
				
				// 파일 업로드
				try {
					// S3에 파일 업로드
					String fileUrl = s3FileUploadService.upload(upload);
					String fileName = fileUrl.substring(base.length());
					// 파일이 성공적으로 업로드 시 db에 데이터 저장
					if (fileUrl != null) {
						System.out.println("사진이 게시판에 성공적으로 업로드");
						to.setU_filename(fileName);
						to.setU_filesize(upload.getSize());
					}

				} catch (Exception e) { e.printStackTrace(); }
				
				
				int flag = boardDAO.boardWriteOk(to);
				
				modelAndView.setViewName("board_write_ok1");
				
				// 데이터 넘겨주기
				modelAndView.addObject( "flag" , flag );
				
				
			return modelAndView;
		}

// 수정 =====================================================================================
		@RequestMapping("/board_modify1.do") 
		public ModelAndView boardModify( HttpServletRequest request, Authentication authentication) {
		
			// TO DAO 호출
			BoardTO to = new BoardTO();
			
			to.setU_seq(request.getParameter("seq") );
			
			Object principal = authentication.getPrincipal();
			CustomUserDetails customUserDetails = (CustomUserDetails) principal;
			String seq = customUserDetails.getM_seq();
			String name = customUserDetails.getM_name();
			String profilename = customUserDetails.getM_profilename();
			to.setM_seq(seq);
			
			BoardListTO listTo = new BoardListTO();
			listTo.setCpage( Integer.parseInt(request.getParameter("cpage" ) ) );
			
			to = boardDAO.boardView(to);
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("board_modify1");
			
			// 데이터 넘겨주기
			modelAndView.addObject( "to" , to );
			modelAndView.addObject( "listTo" , listTo );
			modelAndView.addObject( "name" , name );
			modelAndView.addObject("profilename" , profilename );
			
			return modelAndView;
		}

		@RequestMapping("/board_modify_ok1.do") 
		public ModelAndView boardModifyOK( HttpServletRequest request, Authentication authentication
				, @RequestParam("upload") MultipartFile upload) throws Exception {
		
			// TO DAO 호출
			BoardTO to = new BoardTO();
			
			to.setU_seq(request.getParameter("seq") );

			Object principal = authentication.getPrincipal();
			CustomUserDetails customUserDetails = (CustomUserDetails) principal;
			String seq = customUserDetails.getM_seq();
			to.setM_seq(seq);
			
			BoardListTO listTo = new BoardListTO ();
			listTo.setCpage( Integer.parseInt(request.getParameter( "cpage" ) ) );

			to.setU_subject( request.getParameter( "subject" ) );
			to.setU_content( request.getParameter( "content" ) );
			
			// 파일 업로드
			try {
				// S3에 파일 업로드
				String fileUrl = s3FileUploadService.upload(upload);
				String fileName = fileUrl.substring(base.length());
				// 파일이 성공적으로 업로드 시 db에 데이터 저장
				if (fileUrl != null) {
					System.out.println("사진이 게시판에 성공적으로 수정 업로드");
					to.setU_filename(fileName);
					to.setU_filesize(upload.getSize());
				}

			} catch (Exception e) { e.printStackTrace(); }
			
			
			int flag = boardDAO.boardModifyOk(to);
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("board_modify_ok1");
			
			// 데이터 넘겨주기
			modelAndView.addObject("flag" , flag);
			modelAndView.addObject("to" , to);
			modelAndView.addObject("listTo" , listTo);
			
			return modelAndView;
		}
		
// 삭제 ===========================================================================
		@RequestMapping("/board_delete_ok1.do") 
		public ModelAndView boardDeleteOK( HttpServletRequest request, Authentication authentication) {
		
			// TO DAO 호출
			BoardTO to = new BoardTO();
			
			Object principal = authentication.getPrincipal();
			CustomUserDetails customUserDetails = (CustomUserDetails) principal;
			String seq = customUserDetails.getM_seq();
			to.setM_seq(seq);
			
			BoardListTO listTo = new BoardListTO();
			listTo.setCpage(Integer.parseInt( request.getParameter( "cpage" ) ) );
			
			int flag = boardDAO.boardDeleteOk(to);
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("board_delete_ok1");
			
			// 데이터 넘겨주기
			modelAndView.addObject( "flag" , flag );
			modelAndView.addObject( "listTo" , listTo );
			
			return modelAndView;
		}
	
	
}
