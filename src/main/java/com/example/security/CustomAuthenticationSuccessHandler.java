package com.example.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.example.model.MemberTO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
    	System.out.println("세션설정 시작");
    	UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String mSeq = userDetails.getUsername(); // mSeq 값을 사용할 수 있는 필드로 가정
        
    	
        // Store the user details in the session
        HttpSession session = request.getSession();
        session.setAttribute("mSeq", mSeq);
        System.out.println("세션설정 중");
        // Redirect to a success URL or perform any additional actions
        response.sendRedirect("/main.do");
        System.out.println("세션설정 끝");
    }
}
