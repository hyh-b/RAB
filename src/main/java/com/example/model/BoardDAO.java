package com.example.model;

import java.io.File;
import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.BoardMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class BoardDAO {

	@Autowired
	private BoardMapperInter mapper;

	public ArrayList<BoardTO> boardList(BoardListTO listTo) {
		ArrayList<BoardTO> boardList = (ArrayList<BoardTO>) mapper.boardList(listTo);

		int cpage = listTo.getCpage();
		int recordPerPage = listTo.getRecordPerPage();
		int blockPerPage = listTo.getBlockPerPage();

		// 총 데이터 개수를 listTo 객체에 설정
		int totalRecord = boardList.size();
		listTo.setTotalRecord(totalRecord);

		listTo.setTotalPage(((listTo.getTotalRecord() - 1) / recordPerPage) + 1);

		int skip = (cpage - 1) * recordPerPage;

		// 조회할 데이터 범위 계산
		int endIndex = Math.min(skip + recordPerPage, totalRecord);
		// 데이터 조회 범위 유효 검사
		if (skip < endIndex) {
			// 리스트에서 skip부터 endIndex 직전까지의 데이터
			boardList = new ArrayList<>(boardList.subList(skip, endIndex));
		} else {
			boardList.clear();
		}

		listTo.setStartBlock(cpage - (cpage - 1) % blockPerPage);
		listTo.setEndBlock(cpage - (cpage - 1) % blockPerPage + blockPerPage - 1);
		if (listTo.getEndBlock() >= listTo.getTotalPage()) {
			listTo.setEndBlock(listTo.getTotalPage());
		}
		return boardList;
	}

	public BoardTO boardView(BoardTO to) {
		mapper.viewHit(to);
		to = mapper.view(to);

		return to;
	}

	public int boardWriteOk(BoardTO to) {
		int flag = 1;
		int result = mapper.write_ok(to);

		if (result == 1) {
			flag = 0;
		} else {
			flag = 1;
		}

		return flag;
	}

	public BoardTO boardModify(BoardTO to) {
		to = mapper.modify(to);
		return to;
	}

	public int boardModifyOk(BoardTO to) {
		int flag = 1;

		// 부모 데이터 조회
		BoardTO oldData = mapper.modify_ok_select_parentInfo(to);
		if (oldData != null) {
			to.setOldFilename(oldData.getU_filename()); // 조회된 이전 파일 이름을 설정
		}
		// 파일 수정 할 경우
		if (to.getU_filename() != null) {
			int result = mapper.modify_ok_withFile(to);
			if (result == 1) {
				flag = 0;
				if (to.getU_filename() != null && to.getOldFilename() != null) {
					// 이전 파일 삭제
					File file = new File(to.getUploadPath(), to.getOldFilename());
					file.delete();
				}
			}

		} else {
			// 글만 수정 할 경우
			int result = mapper.modify_ok_noFile(to);
			if (result == 1) {
				flag = 0;
			}
		}
		return flag;
	}

	public int boardDeleteOk(BoardTO to) {
		int flag = 1;
		int result = mapper.delete_ok(to);
		if (result == 1) {
			flag = 0;
		}
		return flag;
	}

}
