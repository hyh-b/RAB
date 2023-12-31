package com.example.mappers;

import java.math.BigDecimal;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.MainTO;


@Mapper
public interface MainMapperInter {
	

	
//-------달력값기준으로 4elements에 쿼리 전달
	@Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_seq = #{seq} and i.i_day= #{day};")
	public List<MainTO> DataFromDateForMain(@Param("seq") int seq, @Param("day") String day);
	
//---------정보입력시 IntakeData레코드 하루 생성.
    @Insert("INSERT INTO IntakeData (m_seq) SELECT m.m_seq FROM Member m LEFT JOIN IntakeData i ON m.m_seq = i.m_seq WHERE i.m_seq IS NULL AND m.m_id = #{mId} LIMIT 1;")
    public int InsertDataForMain(String mId);

//---------로그인과 동시에 참조레코드가 없다면 m_seq를 조회해서 앞뒤 한달치 레코드를 만들고, 하루하루 로그인 할때마다 하루씩 레코드가 앞당겨져서 생김
    @Insert("INSERT INTO IntakeData (m_seq, i_day) SELECT #{seq}, DATE_ADD(CURRENT_DATE(), INTERVAL num DAY) AS i_day FROM (SELECT -30 + n1.n + n10.n * 10 AS num FROM (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) n1 CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) n10) n WHERE DATE_ADD(CURRENT_DATE(), INTERVAL num DAY) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH) AND DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH) AND NOT EXISTS (SELECT 1 FROM IntakeData WHERE m_seq = #{seq} AND i_day = DATE_ADD(CURRENT_DATE(), INTERVAL num DAY) );")
    public int CreateThreeMonthRecord(@Param("seq") String seq);

//------------Charts-------------------------------------------------------------------------
    
    //pie Chart( 합연산 된 칼럼을 가져와서 뿌려줌 , 하루에 먹은 모든 음식의 탄단지가 파이로 그려짐)
    @Select("select * from IntakeData where m_seq= #{seq} and i_day =#{day};")
    public List<MainTO> PieChartData(@Param("seq") int seq, @Param("day") String day);

    //bar Chart (선택된 날짜 기준 +-3일씩 가져와서 일주일치 데이터를 가져옴)
    @Select("SELECT * FROM IntakeData WHERE m_seq = #{seq} AND i_day BETWEEN DATE_SUB(#{day}, INTERVAL 3 DAY) AND DATE_ADD(#{day}, INTERVAL 3 DAY);")
    public List<MainTO> BarChartData(@Param("seq") int seq, @Param("day") String day);
    
    //area Chart (저번 주 , 이번 주 한번에 가져오기)
    @Select("SELECT i_used_kcal, i_day, '이번주' as week FROM IntakeData WHERE m_seq=#{seq} AND YEARWEEK(i_day) = YEARWEEK(#{day}) UNION ALL SELECT i_used_kcal, i_day, '저번주' as week FROM IntakeData WHERE m_seq=#{seq} AND YEARWEEK(i_day) = YEARWEEK(DATE_SUB(#{day}, INTERVAL 1 WEEK)) ORDER BY i_day;")
    public List<MainTO> AreaChartData(@Param("seq") int seq, @Param("day") String day);
    
    //line Chart
    @Select("SELECT SUM(i_weight) as total_weight, DATE_FORMAT(i_day, '%Y-%m') as month, COUNT(DISTINCT CASE WHEN i_weight > 0 THEN DATE_FORMAT(i_day, '%Y-%m-%d') END) as dayCount FROM IntakeData WHERE m_seq=#{seq} AND DATE_FORMAT(i_day, '%Y') = #{year} GROUP BY month ORDER BY month;")
    public List<MainTO> LineChartData(@Param("seq") int seq, @Param("year") String year);

//---update문  아 점 저 -> i_kcal 총 칼로리 ---------------------------------
    
    @Update("UPDATE IntakeData SET i_breakfast_kcal = (SELECT COALESCE(SUM(b_kcal), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}), i_lunch_kcal = (SELECT COALESCE(SUM(l_kcal), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}), i_dinner_kcal = (SELECT COALESCE(SUM(d_kcal), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionBLDperDay(@Param("seq") int seq, @Param("day") String day);
    
    //연산결과 3개를 합쳐서 i_kcal에 할당하는거 하나, main페이지에서  때마다 실행, 추가된 값이 없다면 update만 안되고 나머지는 정상 작동
    @Update("UPDATE IntakeData SET i_kcal = COALESCE(i_breakfast_kcal, 0) + COALESCE(i_lunch_kcal, 0) + COALESCE(i_dinner_kcal, 0) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionAllCalories(@Param("seq") int seq, @Param("day") String day);
    
    //---탄단지콜나당 통합---------------------------------
    @Update("UPDATE IntakeData SET i_carbohydrate_g = (SELECT COALESCE(SUM(b_carbohydrate_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_carbohydrate_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_carbohydrate_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_protein_g = (SELECT COALESCE(SUM(b_protein_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_protein_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_protein_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_fat_g = (SELECT COALESCE(SUM(b_fat_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_fat_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_fat_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_cholesterol_mgl = (SELECT COALESCE(SUM(b_cholesterol_mg), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_cholesterol_mg), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_cholesterol_mg), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}), i_sodium_mg = (SELECT COALESCE(SUM(b_sodium_mg), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_sodium_mg), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_sodium_mg), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_sugar_g = (SELECT COALESCE(SUM(b_sugar_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_sugar_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_sugar_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionAllNutritions(@Param("seq") int seq, @Param("day") String day);

//---String seq로 받아서 메인에서 뿌리기 시도 밑에 얘들---------------------------------------------------
    
    @Update("UPDATE IntakeData SET i_breakfast_kcal = (SELECT COALESCE(SUM(b_kcal), 0) FROM Breakfast WHERE Breakfast.b_day = CURDATE() AND Breakfast.m_seq = #{seq}), i_lunch_kcal = (SELECT COALESCE(SUM(l_kcal), 0) FROM Lunch WHERE Lunch.l_day = CURDATE() AND Lunch.m_seq = #{seq}), i_dinner_kcal = (SELECT COALESCE(SUM(d_kcal), 0) FROM Dinner WHERE Dinner.d_day = CURDATE() AND Dinner.m_seq = #{seq}) WHERE m_seq = #{seq} AND i_day = CURDATE();")
    public int MainUnionBLDperDay(@Param("seq") String seq);
    
    //연산결과 3개를 합쳐서 i_kcal에 할당하는거 하나, main페이지에서  때마다 실행, 추가된 값이 없다면 update만 안되고 나머지는 정상 작동
    @Update("UPDATE IntakeData SET i_kcal = COALESCE(i_breakfast_kcal, 0) + COALESCE(i_lunch_kcal, 0) + COALESCE(i_dinner_kcal, 0) WHERE m_seq = #{seq} AND i_day = CURDATE();")
    public int MainUnionAllCalories(@Param("seq") String seq);
    
    //---탄단지콜나당 통합---------------------------------
    @Update("UPDATE IntakeData SET i_carbohydrate_g = (SELECT COALESCE(SUM(b_carbohydrate_g), 0) FROM Breakfast WHERE Breakfast.b_day = CURDATE() AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_carbohydrate_g), 0) FROM Lunch WHERE Lunch.l_day = CURDATE() AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_carbohydrate_g), 0) FROM Dinner WHERE Dinner.d_day = CURDATE() AND Dinner.m_seq = #{seq}),i_protein_g = (SELECT COALESCE(SUM(b_protein_g), 0) FROM Breakfast WHERE Breakfast.b_day = CURDATE() AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_protein_g), 0) FROM Lunch WHERE Lunch.l_day = CURDATE() AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_protein_g), 0) FROM Dinner WHERE Dinner.d_day = CURDATE() AND Dinner.m_seq = #{seq}),i_fat_g = (SELECT COALESCE(SUM(b_fat_g), 0) FROM Breakfast WHERE Breakfast.b_day = CURDATE() AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_fat_g), 0) FROM Lunch WHERE Lunch.l_day = CURDATE() AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_fat_g), 0) FROM Dinner WHERE Dinner.d_day = CURDATE() AND Dinner.m_seq = #{seq}),i_cholesterol_mgl = (SELECT COALESCE(SUM(b_cholesterol_mg), 0) FROM Breakfast WHERE Breakfast.b_day = CURDATE() AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_cholesterol_mg), 0) FROM Lunch WHERE Lunch.l_day = CURDATE() AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_cholesterol_mg), 0) FROM Dinner WHERE Dinner.d_day = CURDATE() AND Dinner.m_seq = #{seq}), i_sodium_mg = (SELECT COALESCE(SUM(b_sodium_mg), 0) FROM Breakfast WHERE Breakfast.b_day = CURDATE() AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_sodium_mg), 0) FROM Lunch WHERE Lunch.l_day = CURDATE() AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_sodium_mg), 0) FROM Dinner WHERE Dinner.d_day = CURDATE() AND Dinner.m_seq = #{seq}),i_sugar_g = (SELECT COALESCE(SUM(b_sugar_g), 0) FROM Breakfast WHERE Breakfast.b_day = CURDATE() AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_sugar_g), 0) FROM Lunch WHERE Lunch.l_day = CURDATE() AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_sugar_g), 0) FROM Dinner WHERE Dinner.d_day = CURDATE() AND Dinner.m_seq = #{seq}) WHERE m_seq = #{seq} AND i_day = CURDATE();")
    public int MainUnionAllNutritions(@Param("seq") String seq);

//---몸무게, 타겟 몸무게 등록 쿼리, 다이얼로그 ---------------------------------------------

    //몸무게 업데이트 
    @Update("UPDATE IntakeData SET i_weight = #{i_weight} WHERE m_seq = #{seq} AND i_day = #{dialogDate};")
    public int WeightUpdate(@Param("i_weight") BigDecimal i_weight, @Param("seq") int seq, @Param("dialogDate") String dialogDate);

     //목표 몸무게 업데이트
     @Update("Update Member set m_target_weight = #{target_weight} where m_seq = #{seq};")
     public int TargetWeightUpdate(@Param("target_weight") BigDecimal target_weight, @Param("seq") int seq);
    
//---피드백 게시판-------------------------------------------------
    
    //피드백 다이얼로그 insert | main에서
    @Insert("INSERT INTO feedback (m_seq, f_id, f_name, f_mail, f_subject, f_content, f_day) VALUES (#{seq}, #{f_id}, #{f_name}, #{f_mail}, #{f_subject}, #{f_content}, now() );")
    public int FeedbackReceived(@Param("seq") int seq, @Param("f_id") String f_id, @Param("f_name") String f_name, @Param("f_mail") String f_mail, @Param("f_subject") String f_subject, @Param("f_content") String f_content);

   //---feedback.do----------------------
    //피드백 게시판 list
    @Select("select f_seq, f_id, f_name, f_mail, f_subject, f_content, f_day, m_seq from feedback order by f_seq desc LIMIT #{pageSize} OFFSET #{offset};")
    public List<MainTO> FeedbackList(@Param("pageSize") int pageSize, @Param("offset") int offset);
  
    //피드백 view
    @Select("select f_seq, f_id, f_name, f_mail, f_subject, f_content, f_day from feedback where f_seq=#{f_seq} and m_seq=#{m_seq}; ")
    public List<MainTO> ViewFeedback(@Param("f_seq") int f_seq, @Param("m_seq") int m_seq);  //
    
    @Select("select f_seq, f_id, f_name, f_mail, f_subject, f_content, f_day, m_seq from feedback where f_id like #{searchWord} order by f_day desc;")
    public List<MainTO> FidList(@Param("searchWord") String searchWord);

    //이름 검색
    @Select("select f_seq, f_id, f_name, f_mail, f_subject, f_content, f_day, m_seq from feedback where f_name like #{searchWord} order by f_day desc;")
    public List<MainTO> FnameList(@Param("searchWord") String searchWord);

    //제목 검색
    @Select("select f_seq, f_id, f_name, f_mail, f_subject, f_content, f_day, m_seq from feedback where f_subject like #{searchWord} order by f_day desc;")
    public List<MainTO> FsubjectList(@Param("searchWord") String searchWord);

    //이미지 삽입
    @Insert("INSERT INTO feedbackFile (f_filename, f_filesize) VALUES (#{nameFile}, #{sizeFile});")
    public int ImageFeedbackInserted(@Param("nameFile") String nameFile, @Param("sizeFile") int sizeFile);
}

