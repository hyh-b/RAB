package com.example.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;


import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.MainMapperInter;


@Repository
@MapperScan("com.example.mappers")
public class MainDAO {
	@Autowired
	private MainMapperInter mapper;
//-------------------------------------------------------------------------
	public ArrayList<MainTO> DateData(int seq, String day ) {

		List<MainTO> datas = (List<MainTO>)mapper.DataFromDateForMain(seq, day);
		
		//System.out.println(" i_day DAO -> " + day);
		//System.out.println("  m_id DAO -> " + seq );

		
	    ArrayList<MainTO> ddatas = new ArrayList<>(datas);
	    
	    return ddatas;
	}
//----------------------Charts below------------------------------------------------------
		
		
//-----------pie---------------
		public ArrayList<MainTO> PieChartData(int seq, String day) {

			List<MainTO> pie = (List<MainTO>)mapper.PieChartData(seq, day);
		
			ArrayList<MainTO> pies = new ArrayList<>(pie);
	    
	    	return pies;
		}
		
//-----------bar---------------
		
		public ArrayList<MainTO> BarChartData(int seq, String day) {

			List<MainTO> bar = (List<MainTO>)mapper.BarChartData(seq, day);
		
			ArrayList<MainTO> bars = new ArrayList<>(bar);
	    
	    	return bars;
		}
//-----------Area---------------

		public ArrayList<MainTO> AreaChartData(int seq, String day) {

			List<MainTO> area = (List<MainTO>)mapper.AreaChartData(seq, day);
		
			ArrayList<MainTO> areas = new ArrayList<>(area);
			
			//System.out.println(" dao 에서 가져온 년도마다의 데이터 -> " + lines);
	    
	    	return areas;
		}
		
//-----------line---------------
		
		public ArrayList<MainTO> LineChartData(int seq, String year) {

			List<MainTO> line = (List<MainTO>)mapper.LineChartData(seq, year);
		
			ArrayList<MainTO> lines = new ArrayList<>(line);
			
			//System.out.println(" dao 에서 가져온 년도마다의 데이터 -> " + lines);
	    
	    	return lines;
		}
		
//----------besides select --------------------------
		
	//---아이디당 1개의 레코드 중복없이 생성-------------------------------------------------------------------------
		
		public int CreateRecord(String seq) {
			
			int flag = 1;
			
			int result = mapper.CreateThreeMonthRecord(seq);
			
			if(result == 1 ) {
				flag = 0;
			}else if(result == 0) {
				flag = 1;
			}
		
			return flag;
					
		}
		
  //---정보입력창에서 하루치 IntakeData 레코드 생성
		
		public int InsertDataForMain(String mId) {
			
			int irecord_flag = 1;
			
			int result = mapper.InsertDataForMain(mId);
			
			return result;
			
		}
	
  //---아 점 저 합연산--------------------------
		
		public int UnionPerDay(int seq, String day) {
			
			int flag_upd = 1;
			
			int result = mapper.UnionBLDperDay(seq, day);
			
			//System.out.println("  union dao 에서 seq -> " + seq );
			
			if(result == 1 ) {
				
				flag_upd = 0;
				
			}else if(result == 0) {
				
				flag_upd = 1;
			}
		
			//System.out.println( " flag_upd ->" + flag_upd);
			
			return flag_upd;
					
		}
		
		//---아 점 저 합연산 3개를 1개의 i_kcal로 총합연산--------------------------
		
		public int UnionAllCalories(int seq, String day) {
			
			int flag_uac = 1;
			
			int result = mapper.UnionAllCalories(seq, day);
			
			//System.out.println("  union dao2 에서 seq -> " + seq );
			
			if(result == 1 ) {
				flag_uac = 0;
			}else if(result == 0) {
				flag_uac = 1;
			}
			
			//System.out.println( " flag_uac ->" + flag_uac);
		
			return flag_uac;
					
		}
		
		//---탄단지 콜나당 하루치 총합--------------------------
		
		public int 	UnionAllNutritions(int seq, String day) {
			
			int flag_uan = 1;
			
			int result = mapper.UnionAllNutritions(seq, day);
			
			if(result == 1 ) {
				flag_uan = 0;
			}else if(result == 0) {
				flag_uan= 1;
			}
			
			//System.out.println( " 탄단지 콜나당 flag isZero = " + flag_uan);
		
			return flag_uan;
					
		}
		
		//---몸무게들 업데이트--------------------------
		
		public int WeightUpdate(BigDecimal i_weight, int seq, String dialogDate) {
			
			int WeightUpdateFlag = 1;
			
			int result = mapper.WeightUpdate(i_weight, seq, dialogDate);
			
			if(result == 1 ) {
				WeightUpdateFlag = 0;
				//System.out.println( " 그 날짜의 몸무게 업데이트 완료 , " + WeightUpdateFlag);
			}else if(result == 0) {
				WeightUpdateFlag = 1;
				//System.out.println( " 몸무게 날짜 업데이트 실패 , " + WeightUpdateFlag);
			}

			return WeightUpdateFlag;
		}
		
		//--목표 몸무게------------------
		public int TargetWeightUpdate(BigDecimal target_weight, int seq) {
			
			int TargetWeightUpdateFlag = 1;
			
			int result = mapper.TargetWeightUpdate(target_weight, seq);
			
			if(result == 1 ) {
				TargetWeightUpdateFlag = 0;
				//System.out.println( " 목표 몸무게 업데이트 완료 , " + TargetWeightUpdateFlag);
			}else if(result == 0) {
				TargetWeightUpdateFlag = 1;
				//System.out.println( " 목표 몸무게 날짜 업데이트 실패 , " + TargetWeightUpdateFlag);
			}

			return TargetWeightUpdateFlag;
		}
		
	//---main으로 다시 넘어올때 합연산 쿼리들 실행 테스트--------------------

		public int MainUnionPerDay(String seq) {
					
					int mainflag_a = 1;
					
					int result = mapper.MainUnionBLDperDay(seq);
					
					//System.out.println(" \n mainflag_a  에서 seq -> " + seq );
					
					if(result == 1 ) {
						
						mainflag_a = 0;
						
					}else if(result == 0) {
						
						mainflag_a = 1;
					}
				
					//System.out.println( " MainUnionPerDay ->" + mainflag_a );
					
					return mainflag_a ;
							
				}
				
		//---아 점 저 합연산 3개를 1개의 i_kcal로 총합연산--------------------------
				
		public int MainUnionAllCalories(String seq) {
					
					int mainflag_c = 1;
					
					int result = mapper.MainUnionAllCalories(seq);
					
					//System.out.println("  String화 된 seq ->  " + seq );
					
					if(result == 1 ) {
						mainflag_c = 0;
					}else if(result == 0) {
						mainflag_c = 1;
					}
					
					//System.out.println( " MainUnionAllCalories ->" + mainflag_c);
				
					return mainflag_c;
							
				}
				
		//---탄단지 콜나당 하루치 총합--------------------------
				
		public int 	MainUnionAllNutritions(String seq) {
					
					int mainflag_c= 1;
					
					int result = mapper.MainUnionAllNutritions(seq);
					
					if(result == 1 ) {
						mainflag_c = 0;
					}else if(result == 0) {
						mainflag_c = 1;
					}
					
					//System.out.println( " MainUnionAllNutritions = " + mainflag_c + "\n");
				
					return mainflag_c;
							
				}
	
	//---main에서 합연산 쿼리들 실행 테스트 끝 --------------------

	 //---피드백---------------------
		//피드백 입력
		public int FeedbackReceived(int seq, String f_id, String f_name, String f_mail, String f_subject, String f_content) {
			int feedbackFlag = 1;
			
			int result = mapper.FeedbackReceived(seq, f_id, f_name, f_mail, f_subject, f_content);
			
			if(result == 1 ) {
				feedbackFlag = 0;
				//System.out.println( " feedbackFlag 완료 , " + feedbackFlag);
			}else if(result == 0) {
				feedbackFlag = 1;
				//System.out.println( " feedbackFlag 실패 , " + feedbackFlag);
			}
			
			return feedbackFlag;
		}
		
	 //---피드백 게시판
		
		public ArrayList<MainTO> ListOfFeedback(int pageSize, int offset){
			
			List<MainTO> feedback_list  = (List<MainTO>)mapper.FeedbackList(pageSize, offset);
			
			ArrayList<MainTO> feedback_lists  = new ArrayList<>(feedback_list);
			
			//System.out.println(" feedback_lists dao 에서 -> " + feedback_lists);
	    
	    	return feedback_lists;
		}
		
	//----피드백 view
		public ArrayList<MainTO> ViewOfFeedback(int f_seq, int m_seq){
			
			List<MainTO> feedback_view  = (List<MainTO>)mapper.ViewFeedback(f_seq, m_seq);
			
			ArrayList<MainTO> feedback_views  = new ArrayList<>(feedback_view);
			
			//System.out.println(" views 피드백 dao 에서 -> " + feedback_views );
	    
	    	return feedback_views ;
		}
		
		
	//----피드백 검색기능
		
		public ArrayList<MainTO> SearchingFeedback(String searchKey, String searchWord){
			
			
			searchWord = "%" + searchWord + "%";
			
			//System.out.println( "dao 에서 키-> " + searchKey);
			//System.out.println( "dao 에서 word-> " + searchWord);
			
			
			
			 switch (searchKey) {
		        case "아이디":
		            List<MainTO> idSearchResult = (List<MainTO>) mapper.FidList(searchWord);
		            return new ArrayList<>(idSearchResult);
		        case "이름":
		            List<MainTO> nameSearchResult = (List<MainTO>) mapper.FnameList(searchWord);
		            return new ArrayList<>(nameSearchResult);
		        case "제목":
		            List<MainTO> subjectSearchResult = (List<MainTO>) mapper.FsubjectList(searchWord);
		            return new ArrayList<>(subjectSearchResult);
		        default:
		            // 검색 키가 잘못된 경우, 빈 리스트를 반환하거나 원하는 에러 처리를 수행합니다.
		        	System.out.println(" 명단에 없습니다");
		            return new ArrayList<>();
		    }
		}
		//----피드백 이미지.
		public int ImageForFeedback(String nameFile, int sizeFile) {
			
			int img_feedback = mapper.ImageFeedbackInserted(nameFile, sizeFile);
					
			//System.out.println(" dao에서 이미지 처리 결과? -> "+ img_feedback);
			
			return img_feedback;
		}
		
}

