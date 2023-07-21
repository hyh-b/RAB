package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PasswordResetTokenTO {
	private String id;
    private long timestamp;
    private long expiration;
}
