package com.example.boardmodel;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardTO {

	
    private int u_seq;
    private int m_seq;
    private String u_subject;
    private String u_comment;
    private String u_category;
    private int u_hit;
    private int u_cmt;
    
}
