package com.example.model;

import org.mybatis.spring.annotation.MapperScan;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.MemberMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class MemberDAO {
	
	@Autowired
	private MemberMapperInter mapper;
	
	@Autowired
	public MemberDAO(MemberMapperInter mapper) {
	    this.mapper = mapper;
	}
	//회원가입 성공 여부 flag로 확인
	public int signup_ok(MemberTO to) {
		int flag = 1;
		
		int result = mapper.signup_ok(to);
		
		if( result == 1 ) {
			flag = 0;
		}
       
		return flag;
	}
	//회원가입 성공 여부 flag로 확인
	public int kSignup_ok(MemberTO to) {
		int flag = 1;
		
		int result = mapper.kSignup_ok(to);
		
		if( result == 1 ) {
			flag = 0;
		}
       
		return flag;
	}
	//유저 정보 찾기
	public MemberTO findByMId(String m_id) {
        return mapper.findByMId(m_id);

    }
	//카카오 회원 여부확인
	public MemberTO confirmKakao(String kId) {
		return mapper.confirmKakao(kId);
	}
	//추가 정보입력 성공 여부 flag로 확인
	public int signup2_ok(MemberTO to) {
		int flag = 1;
		
		int result = mapper.signup2(to);
		
		if( result == 1 ) {
			flag = 0;
		}
       
		return flag;
	}
	//아이디 중복체크
	public int idCheck(String m_id) {
		
		int flag = mapper.idCheck(m_id);
		
		return flag;
	}
	//이름 중복체크
	public int nameCheck(String m_name) {
		int flag = mapper.nameCheck(m_name);
		
		return flag;
	}
	
	// 아이디 찾기
	public List<MemberTO> findId(String m_mail){
		List<MemberTO> idList = mapper.findId(m_mail);
		
		return idList;
	}
	
	//비밀번호 찾기
	public int findPw(MemberTO to) {
		
		int flag = mapper.findPw(to);
		return flag;
	}
	
	// 비밀번호 변경
	public int changePw(MemberTO to) {
		int flag = mapper.changePw(to);
		
		return flag;
	}
	
	// 회원 리스트
	public ArrayList<MemberTO> memberList(){
		ArrayList<MemberTO> mList = mapper.memberList();
		
		return mList;
	}
	
	// 회원 리스트 검색
	public ArrayList<MemberTO> searchMemberList(String m_id){
		ArrayList<MemberTO> sList = mapper.searchMemberList(m_id);
		
		return sList;
	};
	
	// 신규 유저 수
	public int newMember(String nDay) {
		int newMember = mapper.newMember(nDay);
		
		return newMember;
	}
	
	// 탈퇴 회원 수
	public int deletedMember(String dDay) {
		int deletedMember = mapper.deletedMember(dDay);
		
		return deletedMember;
	}
	
	public int MandIweightsynced(String m_seq) {
        
        int syncFlag = 1;
        
        int result = mapper.MandIweightsynced(m_seq);
        //System.out.println("result:"+result);
        //System.out.println("다오에스이큐: "+m_seq);
        if(result == 1 ) {
           syncFlag = 0;
           //System.out.println( " synced 정상-> , " + syncFlag);
        }else if(result == 0) {
           syncFlag = 1;
           //System.out.println( " synced 비정상-> , " + syncFlag);
        }
        return syncFlag;

	}

}
