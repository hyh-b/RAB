package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NoticeAlbumTO {
	private int nf_seq;
	private int n_seq;
    private String nf_filename;
    private long nf_filesize;
}
