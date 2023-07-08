package com.example.mappers;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.example.model.MainTO;


@Mapper
public interface MainMapperInter {
	
	
	// 이전 쿼리 = SELECT m.*, i.i_kcal, i.i_weight, i.i_day FROM Member m CROSS JOIN IntakeData i WHERE m.m_id = #{mId} limit 0,1;
	
   @Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId};")
   public List<MainTO> TotalDataForMain(String mId);
	
    @Insert("INSERT INTO IntakeData (m_seq) SELECT m.m_seq FROM Member m LEFT JOIN IntakeData i ON m.m_seq = i.m_seq WHERE i.m_seq IS NULL AND m.m_id = #{mId} LIMIT 1;")
    public int InsertDataForMain(String mId);
    
    @Select("SELECT d.*, b.*, l.* FROM Dinner d JOIN Breakfast b ON d.m_seq = b.m_seq JOIN Lunch l ON d.m_seq = l.m_seq where l_day='2023-07-07'")
    public List<MainTO> FoodData();
    
    //@Select("SELECT E.e_seq, E.m_seq, E.e_day, SUM(E.e_carbohydrate_g) AS total_carbohydrate_g, SUM(E.e_protein_g) AS total_protein_g, SUM(E.e_fat_g) AS total_fat_g, SUM(E.e_sugar_g) AS total_sugar_g, SUM(E.e_cholesterol_mg) AS total_cholesterol_mg, SUM(E.e_sodium_mg) AS total_sodium_mg, SUM(E.e_trans_fat_g) AS total_trans_fat_g, SUM(IFNULL(B.b_kcal, 0)) AS total_b_kcal, SUM(IFNULL(L.l_kcal, 0)) AS total_l_kcal, SUM(IFNULL(D.d_kcal, 0)) AS total_d_kcal, (SUM(IFNULL(B.b_kcal, 0)) + SUM(IFNULL(L.l_kcal, 0)) + SUM(IFNULL(D.d_kcal, 0))) AS total_kcal FROM Eat E LEFT JOIN Breakfast B ON E.e_seq = B.e_seq LEFT JOIN Lunch L ON E.e_seq = L.e_seq LEFT JOIN Dinner D ON E.e_seq = D.e_seq GROUP BY E.e_seq, E.m_seq, E.e_day;")
    //public List<MainTO> EatDataForMain(String mId, Date e_day, Date i_day);
    
   
//	@Select("SELECT m.*, h_kcal, h_muscle FROM Member m CROSS JOIN Hdata h WHERE m.m_id = #{mId};")
//	public List<MainTO> HdataForMain(String mId);

	
	//select * from where m_id=#{mId} and #{calendarCt}=i_day;



	
}
