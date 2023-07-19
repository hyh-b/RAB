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
import com.example.security.CustomUserDetails;
import com.example.upload.S3FileUploadService;

@RestController
public class BoardController {

	@Autowired
	private BoardDAO boardDAO;
	
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
		
	
	@RequestMapping("/board.do")
	public ModelAndView boardList(HttpServletRequest request, Authentication authentication) {
		ModelAndView modelAndView = new ModelAndView();
		
		int cpage = 1;
		if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		BoardListTO listTo = new BoardListTO();
		listTo.setCpage(cpage);
		
		
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		System.out.println("게시판리스트 seq가져와 " + customUserDetails.getM_seq());
		String seq = customUserDetails.getM_seq();
		
		// boardList
		ArrayList<BoardTO> boardLists = boardDAO.boardList(listTo);
		StringBuilder sbHtml = new StringBuilder();
		for ( BoardTO to : boardLists ) {
		sbHtml.append("<div class=\"rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark\">");
		sbHtml.append("<div class=\"flex items-center gap-3 py-5 px-6\">");
		sbHtml.append("<div class=\"h-10 w-10 rounded-full\">");
		sbHtml.append("<img src=\"https://rabfile.s3.ap-northeast-2.amazonaws.com/" + to.getU_profilename() + " alt=\"User\" />");
		sbHtml.append("</div>");
		sbHtml.append("<div>");
		sbHtml.append("<h4 class=\"font-medium text-black dark:text-white\">");
		sbHtml.append(" "+ to.getU_writer()+" ");
		sbHtml.append("</h4>");
		sbHtml.append("<p class=\"font-medium text-xs\">"+ to.getU_wdate() +"</p>");
		sbHtml.append("</div>");
		sbHtml.append("</div>");
		sbHtml.append("<a href=\"#\" class=\"block px-4\">");
		sbHtml.append("<img src=\"https://rabfile.s3.ap-northeast-2.amazonaws.com/" + to.getU_filename() + " alt=\"Cards\" />");
		sbHtml.append("</a>");
		sbHtml.append("<div class=\"p-6\">");
		sbHtml.append("<h4 class=\"mb-3 text-xl font-semibold text-black dark:text-white\">");
		sbHtml.append("<a href=\"#\">"+ to.getU_subject() +"</a>");
		sbHtml.append("</h4>");
		sbHtml.append("<p class=\"font-medium\">");
		sbHtml.append(" "+to.getU_content()+" ");
		sbHtml.append("</p>");
		sbHtml.append("</div>");
		sbHtml.append("</div>");
		}
		modelAndView.setViewName("board");
		
		// 데이터 넘겨주기
		modelAndView.addObject("sbHtml" , sbHtml );
		modelAndView.addObject("listTo" , listTo );
		modelAndView.addObject("seq" , seq );
		
		return modelAndView;
	}
	
	@RequestMapping("/boardWrite.do")
	public ModelAndView boardWrite(HttpServletRequest request, Authentication authentication) {
		ModelAndView modelAndView = new ModelAndView();
		return modelAndView;
	}
	
	
	@RequestMapping("/boardWriteOK.do") 
	public ModelAndView boardWriteOK( HttpServletRequest request,  
			@RequestParam(value = "upload", required = false) MultipartFile upload, Authentication authentication)
			throws Exception {

			BoardTO to = new BoardTO();
			
			to.setU_subject( request.getParameter("subject") );
			to.setU_writer( request.getParameter("writer") );
			to.setU_content( request.getParameter("content") );
			to.setU_category( request.getParameter("category") );
			System.out.println( " BoardDAO WriteOK : ");
			System.out.println( request.getParameter("writer") );
			
			try {
	            // S3에 파일 업로드 
	            String fileUrl = s3FileUploadService.upload(upload);
				// db에 저장된 파일url에서 파일 이름만 가져옴
				String fileName = fileUrl.substring(base.length());
	            
	            // 파일이 성공적으로 업로드 시 db에 데이터 저장
	            if (fileUrl != null) {
	                to.setU_filename(fileName);
	                to.setU_filesize(upload.getSize());
	            }
	        } catch (Exception e) { e.printStackTrace(); }
			
			int flag = boardDAO.boardWriteOk(to);
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("boardWriteOK");

			// 데이터 넘겨주기
			modelAndView.addObject( "flag" , flag );
			
		return modelAndView;
	}
}
