package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.mappers.NoticeBoardMapperInter;
import com.example.model.NoticeAlbumDAO;
import com.example.model.NoticeAlbumTO;
import com.example.model.NoticeBoardDAO;
import com.example.model.NoticeBoardTO;
import com.example.model.NoticeListTO;

import com.example.security.CustomUserDetails;
import com.example.upload.S3FileUploadService;

@RestController
public class NoticeBoardController {

	@Autowired
	private NoticeBoardDAO dao;
	@Autowired
	private NoticeAlbumDAO abdao;
	@Autowired
	private NoticeBoardMapperInter mapper;
	
	// 프로퍼티에서 버킷 이름 할당
		@Value("${cloud.aws.s3.bucket}")
		private String bucket;
		
		//프로퍼티에서 지역 코드 할당
		@Value("${cloud.aws.region.static}")
		private String region;
		
		private final S3FileUploadService s3FileUploadService;
		// 업로드 시 db에 저장되는 url중 고정 부분
		String base = "https://s3.ap-northeast-2.amazonaws.com/rabfile/";

		public NoticeBoardController(S3FileUploadService s3FileUploadService) {
	        this.s3FileUploadService = s3FileUploadService;
	    }


	@RequestMapping("/notice_board.do")
	public ModelAndView notice_board(HttpServletRequest request, Authentication authentication) {
	    int cpage = 1;
	    if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
	        cpage = Integer.parseInt(request.getParameter("cpage"));
	    }

	    NoticeListTO listTO = new NoticeListTO();
	    listTO.setCpage(cpage);

	    listTO = dao.listTO(listTO);
	    
	    List<NoticeBoardTO> data = dao.totalRecord();
	    
	    ModelAndView modelAndView = new ModelAndView();

	    List<NoticeBoardTO> noticeBoardList = dao.getAllNoticeBoard();
	    int startIndex = (cpage - 1) * listTO.getRecordPerPage();
	    int endIndex = Math.min(startIndex + listTO.getRecordPerPage(), noticeBoardList.size());
	    List<NoticeBoardTO> paginatedList = noticeBoardList.subList(startIndex, endIndex);
	    
	    modelAndView.addObject("noticeBoardList", paginatedList);
	    modelAndView.addObject("listTO", listTO);
	    modelAndView.addObject("cpage", cpage);
	    modelAndView.addObject("data", data);
	    modelAndView.setViewName("notice_board");
	    return modelAndView;
	}
	@RequestMapping("/user_notice_board.do")
	public ModelAndView user_notice_board(HttpServletRequest request, Authentication authentication) {
		int cpage = 1;
		if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		NoticeListTO listTO = new NoticeListTO();
		listTO.setCpage(cpage);
		
		listTO = dao.listTO(listTO);
		
		List<NoticeBoardTO> data = dao.totalRecord();
		
		ModelAndView modelAndView = new ModelAndView();
		
		List<NoticeBoardTO> noticeBoardList = dao.getAllNoticeBoard();
		int startIndex = (cpage - 1) * listTO.getRecordPerPage();
		int endIndex = Math.min(startIndex + listTO.getRecordPerPage(), noticeBoardList.size());
		List<NoticeBoardTO> paginatedList = noticeBoardList.subList(startIndex, endIndex);
		
		modelAndView.addObject("noticeBoardList", paginatedList);
		modelAndView.addObject("listTO", listTO);
		modelAndView.addObject("cpage", cpage);
		modelAndView.addObject("data", data);
		modelAndView.setViewName("user_notice_board");
		return modelAndView;
	}

	
	@RequestMapping("/notice_board_view.do")
	public ModelAndView notice_board_view(HttpServletRequest request) {
	    NoticeBoardTO bto = new NoticeBoardTO(); // 게시물 정보 가져오기
	    NoticeAlbumTO ato = new NoticeAlbumTO();
	    
	    //cpage
	    String cpageParam = request.getParameter("cpage");
	    int cpage = cpageParam != null ? Integer.parseInt(cpageParam) : 1;

	    NoticeListTO noticeListTO = new NoticeListTO();
	    noticeListTO.setCpage(cpage);
	    
	    
	    //NoticeFile과 NoticeBoard를 같은 n_seq로 지정하는 부분
	    bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));
	    System.out.println(request.getParameter("n_seq"));
	    ato.setN_seq(Integer.parseInt(request.getParameter("n_seq")));

	    System.out.println(bto.getN_seq());
	    //각각 insert
	    bto = dao.noticeBoardView(bto);
	    ato = dao.noticeFileView(ato);
	    
	   

	    // 조회수 증가 처리
	    int result = dao.updateHitOK(bto); // Pass the entire NoticeBoardTO object

	    // result 값으로 성공 여부를 확인할 수 있음
	    if (result == 1) {
	        System.out.println("조회수 증가 성공");
	    } else {
	        System.out.println("조회수 증가 실패");
	    }
	   


	    System.out.println("제목 -------" + bto.getN_subject());
	    System.out.println("내용 -------" + bto.getN_content());
	    System.out.println("파일이름 -------" + ato.getNf_filename());
	    System.out.println("파일사이즈 -------" + ato.getNf_filesize());

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("notice_board_view");
	    modelAndView.addObject("bto", bto); // 게시물 정보를 ModelAndView에 추가
	    modelAndView.addObject("ato", ato);
	    modelAndView.addObject("noticeListTO", noticeListTO);
	    return modelAndView;
	}
	@RequestMapping("/user_notice_board_view.do")
	public ModelAndView user_notice_board_view(HttpServletRequest request) {
		NoticeBoardTO bto = new NoticeBoardTO(); // 게시물 정보 가져오기
		NoticeAlbumTO ato = new NoticeAlbumTO();
		
		//cpage
		String cpageParam = request.getParameter("cpage");
		int cpage = cpageParam != null ? Integer.parseInt(cpageParam) : 1;
		
		NoticeListTO noticeListTO = new NoticeListTO();
		noticeListTO.setCpage(cpage);
		
		
		//NoticeFile과 NoticeBoard를 같은 n_seq로 지정하는 부분
		bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));
		System.out.println(request.getParameter("n_seq"));
		ato.setN_seq(Integer.parseInt(request.getParameter("n_seq")));
		
		System.out.println(bto.getN_seq());
		//각각 insert
		bto = dao.noticeBoardView(bto);
		ato = dao.noticeFileView(ato);
		
		
		
		// 조회수 증가 처리
		int result = dao.updateHitOK(bto); // Pass the entire NoticeBoardTO object
		
		// result 값으로 성공 여부를 확인할 수 있음
		if (result == 1) {
			System.out.println("조회수 증가 성공");
		} else {
			System.out.println("조회수 증가 실패");
		}
		
		
		
		System.out.println("제목 -------" + bto.getN_subject());
		System.out.println("내용 -------" + bto.getN_content());
		System.out.println("파일이름 -------" + ato.getNf_filename());
		System.out.println("파일사이즈 -------" + ato.getNf_filesize());
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("notice_board_view");
		modelAndView.addObject("bto", bto); // 게시물 정보를 ModelAndView에 추가
		modelAndView.addObject("ato", ato);
		modelAndView.addObject("noticeListTO", noticeListTO);
		return modelAndView;
	}


	
	@RequestMapping("/notice_board_write.do")
	public ModelAndView notice_board_write(HttpServletRequest request, NoticeBoardTO noticeBoardTO) throws SQLException {
	    String cpageParam = request.getParameter("cpage");
	    int cpage = cpageParam != null ? Integer.parseInt(cpageParam) : 1;

	    NoticeListTO noticeListTO = new NoticeListTO();
	    noticeListTO.setCpage(cpage);

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.addObject("noticeListTO", noticeListTO);
	    modelAndView.setViewName("notice_board_write");

	    return modelAndView;
	}
	

	@RequestMapping("/notice_board_write_ok.do")
	public  ModelAndView notice_board_write_ok(HttpServletRequest request, Authentication authentication, MultipartFile upload) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		int jjinSeq = Integer.parseInt(m_seq);
		NoticeBoardTO bto = new NoticeBoardTO();
		NoticeAlbumTO ato = new NoticeAlbumTO();
		int flag = 2;
		bto.setM_seq(jjinSeq);
		String subject = request.getParameter("n_subject");
		bto.setN_subject(subject);
		String content =request.getParameter("n_content");
		bto.setN_content(content);
		int flagAB = dao.writeOK(bto);
		System.out.println("flagAB >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+flagAB);
		
		//flagAB가 들어가야 이것도 넣는다
		if (flagAB == 1  ) {
		
			System.out.println("flag 넣는중 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			try {
	            // S3에 파일 업로드 
	            String fileUrl = s3FileUploadService.upload(upload);
	            
	            // 파일이 성공적으로 업로드 시 db에 데이터 저장
	            if (fileUrl != null) {    
	            	ato.setN_seq(bto.getN_seq());//지렸다
	                ato.setNf_filename(fileUrl);
	                ato.setNf_filesize(upload.getSize());            
	                flag = abdao.noticeAlbum_ok(ato);
	                
	            }else {
	            	ato.setN_seq(bto.getN_seq());
	            	System.out.println("n_seq>>>>>>>>>>>>>>>>>>>>>>>>>"+bto.getN_seq());
	            	flag = abdao.noticeAlbum_ok(ato);
	            }
	        } catch (Exception e) {
	            
	            e.printStackTrace();
	        }
		}
		System.out.println("flag  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+flag);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("noticeboardAlbum_ok");
		modelAndView.addObject("flagAB",flagAB);
		modelAndView.addObject("flag",flag);
		return modelAndView; 
	}
	@RequestMapping("/notice_board_modify_ok.do")
	public ModelAndView notice_board_modify_ok(HttpServletRequest request, Authentication authentication, @RequestParam("upload") MultipartFile upload) {
	    authentication = SecurityContextHolder.getContext().getAuthentication();
	    NoticeBoardTO bto = new NoticeBoardTO();
	    NoticeAlbumTO ato = new NoticeAlbumTO();

	    // n_Seq 값으로 지정
	    bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));
	    System.out.println("n_seq---------" + request.getParameter("n_seq"));
	    ato.setN_seq(Integer.parseInt(request.getParameter("n_seq")));

	    int flag = 2;
	    String subject = request.getParameter("n_subject");
	    bto.setN_subject(subject);
	    String content = request.getParameter("n_content");
	    bto.setN_content(content);

	    int flagAB = dao.updateBoard(bto);
	    System.out.println("flagAB >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + flagAB);

	    // flagAB가 1일 때만 파일 처리를 진행합니다.
	    if (flagAB == 1 && !upload.isEmpty()) {
	        System.out.println("flag 넣는중 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	        try {
	            // S3에 파일 업로드 
	            String fileUrl = s3FileUploadService.upload(upload);

	            // 파일이 성공적으로 업로드 시 db에 데이터 저장
	            if (fileUrl != null) {
	                ato.setN_seq(bto.getN_seq());
	                ato.setNf_filename(fileUrl);
	                ato.setNf_filesize(upload.getSize());
	                flag = abdao.updateNoticeAlbum(ato);

	            } else {
	                // 파일 업로드 실패 시 예외처리 또는 기본값으로 설정합니다.
	                // 예시로 null을 넣어줍니다.
	                ato.setN_seq(bto.getN_seq());
	                ato.setNf_filename(null);
	                ato.setNf_filesize(0L); // 또는 0으로 설정
	                flag = abdao.updateNoticeAlbum(ato);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            // 파일 업로드 실패 시 로그를 출력하고 예외 처리 또는 기본값으로 설정합니다.
	            // 예시로 null을 넣어줍니다.
	            ato.setN_seq(bto.getN_seq());
	            ato.setNf_filename(null);
	            ato.setNf_filesize(0L); // 또는 0으로 설정
	            flag = abdao.updateNoticeAlbum(ato);
	        }
	    }

	    System.out.println("flag  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + flag);
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("noticeboardAlbum_ok");
	    modelAndView.addObject("flagAB", flagAB);
	    modelAndView.addObject("flag", flag);
	    return modelAndView;
	}



	@RequestMapping("/notice_board_modify.do")
	public ModelAndView notice_board_modify(HttpServletRequest request, NoticeBoardTO noticeBoardTO)  {
		int n_seq = Integer.parseInt(request.getParameter("n_seq"));
		
		ModelAndView modelAndView = new ModelAndView();
		
		modelAndView.setViewName("notice_board_modify");
		modelAndView.addObject("n_seq", n_seq);
		return modelAndView;
	}
	
	
	@RequestMapping("/notice_board_delete_ok.do")
	public ModelAndView notice_board_delete(HttpServletRequest request, NoticeBoardTO noticeBoardTO)  {
		
		NoticeBoardTO bto =new NoticeBoardTO();
		bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));
		System.out.println("n_seq ------------"+bto.n_seq);
		int flag = dao.noticeDelete_ok(bto);
		System.out.println("flag-----"+flag);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("noticeboarddelete_ok");
		modelAndView.addObject("flag", flag);
		return modelAndView;
	}
}
	
	

