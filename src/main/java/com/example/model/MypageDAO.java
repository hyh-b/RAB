package com.example.model;

import java.io.File;

import org.mybatis.spring.annotation.MapperScan;
import org.mybatis.spring.annotation.MapperScans;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.MemberMapperInter;
import com.example.mappers.MypageMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class MypageDAO {

	
	 @Autowired private MypageMapperInter mapper;
	 

	public MypageTO Mypage(MypageTO to) {
		to = mapper.mypage(to);
		return to;
	}

	public int MypageModifyOk(MypageTO to) {
		int flag = 1;

		// 부모 데이터 조회
		MypageTO oldData = mapper.mypageModify_ok_select_parentInfo(to);
		if (oldData != null) {
			to.setOldFilename(oldData.getM_filename()); // 조회된 이전 파일 이름을 설정
		}
		// 파일 수정 할 경우
		if (to.getM_filename() != null) {
			int result = mapper.mypageModify_ok_withFile(to);
			if (result == 1) {
				flag = 0;
				if (to.getM_filename() != null && to.getOldFilename() != null) {
					// 이전 파일 삭제
					File file = new File(to.getUploadPath(), to.getOldFilename());
					file.delete();
				}

			} else if (result == 1) {
				flag = 1;
			} 

		} else {
			// 글만 수정 할 경우
			int result = mapper.mypageModify_ok_noFile(to);
			if (result == 1) {
				flag = 0;
			} else if (result == 1) {
				flag = 1;
			}
		}
		return flag;
	}
	
	public int MypageDeleteOk (MypageTO to) {
		int flag = 1;
		int result = mapper.mypageDelete_ok(to);
		if( result == 1 ) {
			flag = 0;
		} else if ( result == 0 ) {
			flag = 1;
		} 
		return flag;
	}
	
	
}
