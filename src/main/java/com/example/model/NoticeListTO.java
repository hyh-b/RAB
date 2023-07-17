package com.example.model;

import java.util.ArrayList;

import com.example.model.NoticeBoardTO;

import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class NoticeListTO {
	private int cpage;
	private int recordPerPage;
	private int blockPerPage;
	private int totalPage;
	private int totalRecord;
	private int startBlock;
	private int endBlock;
	private int blockRecord;
	private ArrayList<NoticeBoardTO> albumLists;
	
	public NoticeListTO() {
		this.cpage = 1;
		this.recordPerPage = 10;	//한 페이지에 보일 글의 수
		this.blockPerPage = 5;	//페이지 보일 개수 5개씩
		this.totalPage = 1;
		this.totalRecord = 0;
		this.blockRecord = 0;
	}
	
	
}
