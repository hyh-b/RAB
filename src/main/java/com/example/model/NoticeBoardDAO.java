package com.example.model;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.NoticeBoardMapperInter;


@Repository
@MapperScan("com.example.mappers")
public class NoticeBoardDAO {
	@Autowired
    private  NoticeBoardMapperInter mapper;

	
	public NoticeBoardTO noticeBoardView(NoticeBoardTO to) {
	    return mapper.noticeBoardView(to);
	}
	public NoticeAlbumTO noticeFileView(NoticeAlbumTO to) {
		return mapper.noticeFileView(to);
	}
	
	public List<NoticeBoardTO> getAllNoticeBoard() {
	    return mapper.getAllNoticeBoard();
	}
    public int writeOK(NoticeBoardTO to) {
    	int flag =0;
	    int result = mapper.writeOK(to);
	    if (result == 1) {
	    	flag =1;  	
	    }
    	return flag;
    }
    public int updateBoard(NoticeBoardTO to) {
    	int flag =0;
	    int result = mapper.updateBoard(to);
	    if (result == 1) {
	    	flag =1;  	
	    }
    	return flag;
    }
    public int updateHitOK(NoticeBoardTO to) {
    	int result = mapper.updateHitOK(to); // Assuming the method in the mapper is named "writeHit"

        if (result == 1) {
            return 1; // 조회수 증가 성공
        } else {
            return 0; // 조회수 증가 실패
        }
    }
    
    
	public List<NoticeBoardTO> totalRecord(){
		List<NoticeBoardTO> lists = mapper.albumList();
		return lists;
	}
	
	public NoticeListTO listTO(NoticeListTO listTO) {
	    ArrayList<NoticeBoardTO> totalList = (ArrayList<NoticeBoardTO>) mapper.albumList();
	    int totalRecord = totalList.size();
	    System.out.println();
	    
	    int cpage = listTO.getCpage();
	    int recordPerPage = listTO.getRecordPerPage();
	    int blockPerPage = listTO.getBlockPerPage();

	    listTO.setTotalRecord(totalRecord);

	    int totalPage = (totalRecord - 1) / recordPerPage + 1;
	    listTO.setTotalPage(totalPage);
	    
	    // 현재 페이지를 기준으로 레코드의 시작 인덱스를 계산
	    int skip = (cpage - 1) * recordPerPage;

	    ArrayList<NoticeBoardTO> lists = new ArrayList<>();
	    
	    // Math.min 함수는 두개의 식에서 값을 비교하여 적은 것을 리턴함.
	    int end = Math.min(skip + recordPerPage, totalRecord);
	    
	    for (int i = skip; i < end; i++) {
	    	NoticeBoardTO album = totalList.get(i);
	    	
	        lists.add(album);
	    }
	    listTO.setAlbumLists(lists);
	    
	    // 현재 페이지가 속한 페이지 블록의 첫 번쨰 페이지로 계산
	    listTO.setStartBlock(((cpage - 1) / blockPerPage) * blockPerPage + 1);
	    
	    // 현재 페이지가 속한 페이지 블록의 첫 번째 페이지계산
//	    listTO.setEndBlock(Math.min(((cpage - 1) / blockPerPage) * blockPerPage + blockPerPage, totalPage));
	    listTO.setEndBlock(Math.min(listTO.getStartBlock() + blockPerPage - 1, listTO.getTotalPage()));
	    return listTO;
	}
	
	public int noticeDelete_ok(NoticeBoardTO to) {
		int flag = 2;
		
		int result = mapper.noticeDelete_ok(to);
		
		if(result ==1) {
			flag = 0;
		}else if(result==0){
			flag=1;
		}
		return flag;
	}
}
