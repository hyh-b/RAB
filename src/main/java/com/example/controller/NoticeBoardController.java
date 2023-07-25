package com.example.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.mappers.NoticeBoardMapperInter;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.example.model.NoticeAlbumDAO;
import com.example.model.NoticeAlbumTO;
import com.example.model.NoticeBoardDAO;
import com.example.model.NoticeBoardTO;
import com.example.model.NoticeListTO;
import com.example.security.CustomUserDetails;
import com.example.security.CustomUserDetailsService;
import com.example.upload.S3FileUploadService;

@RestController
public class NoticeBoardController {

	@Autowired
	private NoticeBoardDAO dao;
	@Autowired
	private NoticeAlbumDAO abdao;
	@Autowired
	private NoticeBoardMapperInter mapper;
	@Autowired
	private MemberDAO m_dao;
	
	@Autowired
	private CustomUserDetailsService customUserDetailsService;
	
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
	public ModelAndView notice_board(HttpServletRequest request, Authentication authentication, String mId) {
	    int cpage = 1;
	    if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
	        cpage = Integer.parseInt(request.getParameter("cpage"));
	    }
	    
	    authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		//System.out.println(seq);
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
		
        String m_profilename =  customUserDetails.getM_profilename();
        
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
	    modelAndView.addObject("zzinid", member.getM_id());
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("profilename", m_profilename);
	    return modelAndView;
	}
	@RequestMapping("/user_notice_board.do")
	public ModelAndView user_notice_board(HttpServletRequest request, Authentication authentication, String mId) {
		int cpage = 1;
		if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		 authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		//System.out.println(seq);
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
		
        String m_profilename =  customUserDetails.getM_profilename();
	        
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
		modelAndView.addObject("zzinid", member.getM_id());
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("profilename", m_profilename);
		return modelAndView;
	}

	
	@RequestMapping("/notice_board_view.do")
	public ModelAndView notice_board_view(HttpServletRequest request, Authentication authentication, String mId) {
	    NoticeBoardTO bto = new NoticeBoardTO(); // 게시물 정보 가져오기
	    
	    authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		//System.out.println(seq);
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
		
        String m_profilename =  customUserDetails.getM_profilename();
	    
	    
	    //cpage
	    String cpageParam = request.getParameter("cpage");
	    int cpage = cpageParam != null ? Integer.parseInt(cpageParam) : 1;

	    NoticeListTO noticeListTO = new NoticeListTO();
	    noticeListTO.setCpage(cpage);

	    //NoticeFile과 NoticeBoard를 같은 n_seq로 지정하는 부분
	    bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));

	    // 각각 insert
	    bto = dao.noticeBoardView(bto);
	    NoticeAlbumTO ato = new NoticeAlbumTO();
	    ato.setN_seq(bto.getN_seq());
	    List<NoticeAlbumTO> atos = abdao.noticeFilelistView(ato);

	    // 조회수 증가 처리
	    int result = dao.updateHitOK(bto); // Pass the entire NoticeBoardTO object

	  


	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("notice_board_view");
	    modelAndView.addObject("bto", bto); // 게시물 정보를 ModelAndView에 추가
	    modelAndView.addObject("atos", atos);
	    modelAndView.addObject("noticeListTO", noticeListTO);
	    modelAndView.addObject("zzinid", member.getM_id());
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("profilename", m_profilename);
	    return modelAndView;
	}



	@RequestMapping("/user_notice_board_view.do")
	public ModelAndView user_notice_board_view(HttpServletRequest request, Authentication authentication, String mId) {
	    NoticeBoardTO bto = new NoticeBoardTO(); // 게시물 정보 가져오기
	    
	    
	    authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		//System.out.println(seq);
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
		
        String m_profilename =  customUserDetails.getM_profilename();
	    
	    

	    //cpage
	    String cpageParam = request.getParameter("cpage");
	    int cpage = cpageParam != null ? Integer.parseInt(cpageParam) : 1;

	    NoticeListTO noticeListTO = new NoticeListTO();
	    noticeListTO.setCpage(cpage);

	    //NoticeFile과 NoticeBoard를 같은 n_seq로 지정하는 부분
	    bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));

	    // 각각 insert
	    bto = dao.noticeBoardView(bto);
	    NoticeAlbumTO ato = new NoticeAlbumTO();
	    ato.setN_seq(bto.getN_seq());
	    List<NoticeAlbumTO> atos = abdao.noticeFilelistView(ato);

	    // 조회수 증가 처리
	    int result = dao.updateHitOK(bto); // Pass the entire NoticeBoardTO object

	    

	   

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("user_notice_board_view");
	    modelAndView.addObject("bto", bto); // 게시물 정보를 ModelAndView에 추가
	    modelAndView.addObject("atos", atos);
	    modelAndView.addObject("noticeListTO", noticeListTO);
	    modelAndView.addObject("zzinid", member.getM_id());
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("profilename", m_profilename);
	    return modelAndView;
	}

	


	
	@RequestMapping("/notice_board_write_ok.do")
	public Map<String, Object> writeOKAjax(HttpServletRequest request, @RequestParam("uploads") MultipartFile[] uploads) {
		CustomUserDetails customUserDetails = customUserDetailsService.getCurrentUserDetails();
		String m_seq=customUserDetails.getM_seq();
		NoticeBoardTO bto = new NoticeBoardTO();
	    NoticeAlbumTO ato = new NoticeAlbumTO();
	    
	    String subject = request.getParameter("n_subject");
	    bto.setN_subject(subject);
	    String content = request.getParameter("n_content");
	    bto.setN_content(content);
	    bto.setM_seq(Integer.parseInt(m_seq));

	    Map<String, Object> response = new HashMap<>();
	    int flagAB = dao.writeOK(bto);

	    int flag = 0;
	    if (flagAB == 1) {
	        for (MultipartFile file : uploads) {
	            try {
	                // Upload file to S3
	                String fileUrl = s3FileUploadService.upload(file);

	                // If the file was uploaded successfully, save its data to the database
	                if (fileUrl != null) {
	                    ato.setN_seq(bto.getN_seq());
	                    ato.setNf_filename(fileUrl);
	                    ato.setNf_filesize(file.getSize());
	                    flag = abdao.noticeAlbum_ok(ato);
	                } else {
	                    //System.out.println("File upload failed for n_seq: " + bto.getN_seq());
	                }
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }
	    }

	    response.put("flagAB", flagAB);
	    response.put("flag", flag);
	    return response;
	}
	@RequestMapping("/notice_board_delete_ok.do")
	public Map<String, Object> notice_board_delete(HttpServletRequest request, NoticeBoardTO noticeBoardTO)  {
		Map<String, Object> response = new HashMap<>();
		NoticeBoardTO bto =new NoticeBoardTO();
		bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));
		//System.out.println("n_seq ------------"+bto.n_seq);
		int flag = dao.noticeDelete_ok(bto);
		//System.out.println("flag-----"+flag);
		
		response.put("flag", flag);
		return response;
	}


	
	
	@RequestMapping("/notice_board_modify_ok.do")
	public Map<String, Object> notice_board_modify_ok(HttpServletRequest request, Authentication authentication, @RequestParam("upload") MultipartFile[] upload) {
		Map<String, Object> response = new HashMap<>();
		authentication = SecurityContextHolder.getContext().getAuthentication();
	    NoticeBoardTO bto = new NoticeBoardTO();
	    NoticeAlbumTO ato = new NoticeAlbumTO();

	    // n_Seq 값으로 지정
	    bto.setN_seq(Integer.parseInt(request.getParameter("n_seq")));
	    //System.out.println("n_seq---------" + request.getParameter("n_seq"));
	    ato.setN_seq(Integer.parseInt(request.getParameter("n_seq")));

	    int flag = 2;
	    String subject = request.getParameter("n_subject");
	    bto.setN_subject(subject);
	    String content = request.getParameter("n_content");
	    bto.setN_content(content);

	    // Update the NoticeBoard data and delete all NoticeFile data with the same n_seq
	    int flagAB = dao.updateBoard(bto);
	    abdao.noticeFileDelete_ok(ato); // pass the ato object

	    //System.out.println("flagAB >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + flagAB);

	    // flagAB가 1일 때만 파일 처리를 진행합니다.
	    if (flagAB == 1 && upload.length > 0) {
	        //System.out.println("flag 넣는중 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	        for (MultipartFile file : upload) {
	            try {
	                // Upload new file and insert new entry to NoticeFile
	                // Upload file to S3
	                String fileUrl = s3FileUploadService.upload(file);

	                // If the file was successfully uploaded, save data to db
	                if (fileUrl != null) {
	                    ato.setN_seq(bto.getN_seq());
	                    ato.setNf_filename(fileUrl);
	                    ato.setNf_filesize(file.getSize());
	                    flag = abdao.noticeAlbum_ok(ato);
	                } else {
	                    // If the file upload failed, set default values
	                    ato.setN_seq(bto.getN_seq());
	                    ato.setNf_filename(null);
	                    ato.setNf_filesize(0L); // or set to 0
	                    flag = abdao.noticeAlbum_ok(ato);
	                }
	            } catch (Exception e) {
	                e.printStackTrace();
	                // If the file upload failed, log the error and set default values
	                ato.setN_seq(bto.getN_seq());
	                ato.setNf_filename(null);
	                ato.setNf_filesize(0L); // or set to 0
	                flag = abdao.noticeAlbum_ok(ato);
	            }
	        }
	    }

	   // System.out.println("flag  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + flag);
	  
	    response.put("flagAB", flagAB);     
	    response.put("flag", flag);     
	  
		return response;
	}




	@RequestMapping("/notice_board_modify.do")
	public ModelAndView notice_board_modify(HttpServletRequest request, NoticeBoardTO noticeBoardTO, Authentication authentication, String mId)  {
		int n_seq = Integer.parseInt(request.getParameter("n_seq"));
		
		
		authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		//System.out.println(seq);
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
		
        String m_profilename =  customUserDetails.getM_profilename();
		
		
		
		ModelAndView modelAndView = new ModelAndView();
		
		modelAndView.setViewName("notice_board_modify");
		modelAndView.addObject("n_seq", n_seq);
		modelAndView.addObject("zzinid", member.getM_id());
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("profilename", m_profilename);
		return modelAndView;
	}
	
	
	
	
	@RequestMapping("/notice_board_write.do")
	public ModelAndView notice_board_write(HttpServletRequest request, NoticeBoardTO noticeBoardTO, Authentication authentication, String mId) throws SQLException {
	    String cpageParam = request.getParameter("cpage");
	    int cpage = cpageParam != null ? Integer.parseInt(cpageParam) : 1;

	    
	    authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		//System.out.println(seq);
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
		
        String m_profilename =  customUserDetails.getM_profilename();
		
        
	    NoticeListTO noticeListTO = new NoticeListTO();
	    noticeListTO.setCpage(cpage);

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.addObject("noticeListTO", noticeListTO);
	    modelAndView.setViewName("notice_board_write");
	    modelAndView.addObject("zzinid", member.getM_id());
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("profilename", m_profilename);
	    return modelAndView;
	}
}
	
	
