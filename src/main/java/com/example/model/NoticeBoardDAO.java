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


    public List<NoticeBoardTO> getAllNoticeBoard() {
  
        return mapper.getAllNoticeBoard();
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
}
