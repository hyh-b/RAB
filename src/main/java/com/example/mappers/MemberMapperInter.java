package com.example.mappers;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.model.ExerciseTO;
import com.example.model.MainTO;
import com.example.model.MemberTO;

@Mapper
public interface MemberMapperInter {
	
	//회원가입
	@Insert("insert into Member(m_seq, m_id,m_pw,m_mail,m_iskakao,m_role,m_join_date,m_profilename,m_backgroundfilename) values (0,#{m_id},#{m_pw},#{m_mail},0,#{m_role},now(),'KakaoTalk_20230719_171617369.jpg','KakaoTalk_20230719_171612219.png');")
	public int signup_ok(MemberTO to);
	
	//카카오 회원가입
	@Insert("insert into Member(m_seq, m_id,m_pw,m_mail,m_iskakao, m_role, m_join_date,m_profilename,m_backgroundfilename) values (0,#{m_id},#{m_pw},#{m_mail},1,#{m_role},now(),'KakaoTalk_20230719_171617369.jpg','KakaoTalk_20230719_171612219.png');")
	public int kSignup_ok(MemberTO to);
	
	//아이디를 통한 유저 정보조회
	@Select("SELECT * FROM Member WHERE m_id = #{m_id}")
	public MemberTO findByMId(String m_id);
	
	//카카오 회원여부 확인
	@Select("select m_id from Member where m_id = #{kId}")
	public MemberTO confirmKakao(String kId);
	
	//추가 정보입력 
	@Update("UPDATE Member SET m_name = #{m_name}, m_gender = #{m_gender} , m_weight = #{m_weight}, m_height = #{m_height}, m_tel = #{m_tel}, m_role = #{m_role}, m_target_calorie = #{m_target_calorie}, m_target_weight = #{m_target_weight},m_birthday = #{m_birthday}, m_real_name=#{m_real_name} WHERE m_id = #{m_id};")
	public int signup2(MemberTO to);
	
	//아이디 중복확인
	@Select("SELECT count(m_id) FROM Member WHERE m_id = #{m_id}")
	public int idCheck(String m_id);
	
	//닉네임 중복확인
	@Select("SELECT count(m_name) FROM Member WHERE m_name = #{m_name}")
	public int nameCheck(String m_name);
	
	// 아이디 찾기
	@Select("select m_id from Member where m_mail=#{m_mail}")
	public List<MemberTO> findId(String m_mail);
	
	// 비밀번호 찾기
	@Select("select count(*) from Member where m_id=#{m_id} and m_mail=#{m_mail}")
	public int findPw(MemberTO to);
	
	// 비밀번호 변경
	@Update("update Member set m_pw=#{m_pw} where m_id=#{m_id}")
	public int changePw(MemberTO to);
	
	// 회원 리스트
	@Select("select m_id, m_real_name, m_name, m_mail from Member")
	public ArrayList<MemberTO> memberList();
	
	// 회원 리스트 검색
	@Select("select m_id, m_real_name, m_name, m_mail from Member where m_id like concat('%', #{m_id}, '%')")
	public ArrayList<MemberTO> searchMemberList(String m_id);
	
	// 신규유저 수 검색
	@Select("select count(*) from Member where m_join_date=#{nDay}")
	public int newMember(String nDay);
	
	// 삭제유저 수 검색
	@Select("SELECT COUNT(*) FROM deletedMember where deletedDate = #{dDay}")
	public int deletedMember(String dDay);
	
	@Update("UPDATE IntakeData JOIN Member ON IntakeData.m_seq = Member.m_seq SET IntakeData.i_weight = Member.m_weight WHERE IntakeData.i_day = CURDATE() and IntakeData.m_seq = #{m_seq};")
    public int MandIweightsynced(String m_seq);
	
	@Update("UPDATE IntakeData SET i_weight=#{i_weight} WHERE m_seq=#{m_seq} AND i_day=CURDATE();")
	public int i_weightUpdate(MainTO to);
	

}
