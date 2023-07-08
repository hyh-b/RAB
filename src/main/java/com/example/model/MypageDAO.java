package com.example.model;

import java.io.File;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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

		// 이전 데이터 조회
		MypageTO oldData = mapper.mypageModify_ok_select_parentInfo(to);

		if (oldData != null) {
			// 조회된 이전 프로필 사진 파일명 설정
			to.setOldProFileFilename(oldData.getM_profilename() );
			// 조회된 이전 배경 사진 파일명 설정
			to.setOldBackgroundFilename(oldData.getM_backgroundfilename() );
		}

		System.out.println("if 전 to.getM_backgroundfilename() >>>>>>>>>>>> " + to.getM_backgroundfilename());
		if (to.getM_profilename() != null) {
			System.out.println("if 전 to.getM_profilename() >>>>>>>>>>>> " + to.getM_profilename());
			System.out.println("if 전 to.getM_profilename() 길이>>>>>>>>>>>> " + to.getM_profilename().length());
		} else {
			System.out.println("to.getM_profilename() is null");
		}

		// 배경 사진만 변경할 경우
		if (to.getM_backgroundfilename() != null) {
			if (to.getM_backgroundfilename().length() != 0) {
				// 배경 사진 변경하는 경우 처리
				System.out.println("DAO에서 배사 처리 하러 슝슝");
				flag = modifyBackground(to);
				if (flag == 1) {
					return flag;
				}
			}
		}

		// 프로필 사진만 변경할 경우
		if (to.getM_profilename() != null) {
			if (to.getM_profilename().length() != 0) {
				// 프사 변경하는 경우 처리
				System.out.println("DAO에서 프사 처리하러 슝슝");
				flag = modifyProfile(to);
				if (flag == 1) {
					return flag;
				}
			}
		}

		flag = modifyTextOnly(to);
		
		return flag;
	}

	// 배경 사진만 변경하는 경우 처리
	public int modifyBackground(MypageTO to) {
		int flag = 1;
		int result = mapper.mypageModify_ok_Background(to);
		System.out.println("DAO modifyBackground() 호출 " + result );
		
		if (result == 1) {
			flag = 0;
			if (to.getOldBackgroundFilename() != null) {
				// 이전 배경 사진 파일 삭제
				File backgroundFile = new File(to.getUploadPath(), to.getOldBackgroundFilename());
				if (backgroundFile.delete() == false) {
					System.out.println("에러가 났어요 ");
				}
			}
		}
		return flag;
	}

	// 프로필 사진만 변경하는 경우 처리
	public int modifyProfile(MypageTO to) {
		int flag = 1;
		int result = mapper.mypageModify_ok_Profile(to);
		System.out.println("DAO modifyProfile() 호출 ");

		if (result == 1) {
			flag = 0;
			if (to.getOldProFileFilename() != null) {
				// 이전 프로필 사진 파일 삭제
				File profileFile = new File(to.getUploadPath(), to.getOldProFileFilename());
				System.out.println("to.getOldProFileFilename()" + to.getOldProFileFilename() ) ;
				System.out.println("to.getUploadPath()" + to.getUploadPath() ) ;

				profileFile.delete();
			}
		}
		return flag;
	}

	// 글만 수정하는 경우 처리
	public int modifyTextOnly(MypageTO to) {
		int result = mapper.mypageModify_ok_noFile(to);
		return result == 1 ? 0 : 1;
	}

	// 삭제
	public int MypageDeleteOk(MypageTO to) {
		int flag = 1;
		int result = mapper.mypageDelete_ok(to);
		if (result == 1) {
			flag = 0;
		} else if (result == 0) {
			flag = 1;
		}
		System.out.println("delete dao flag :  " + flag);
		return flag;
	}

}
