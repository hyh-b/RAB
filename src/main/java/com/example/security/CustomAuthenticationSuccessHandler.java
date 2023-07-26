package com.example.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;
// 로그인에 성공할시 적용되는 클래스
@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        
        HttpSession session = request.getSession();
        //카카오 로그인 유저 엑세스토큰 저장
        String tempUserInfo = (String) session.getAttribute("userInfo");
        String tempAccessToken = (String) session.getAttribute("access_token");
        
        if(tempUserInfo != null) {
        	
        session = request.getSession(true);
        session.setAttribute("userInfo", tempUserInfo);
        session.setAttribute("access_token", tempAccessToken);
        }
        
        // 로그인시 ADMIN 권한이 있는 유저는 admin.do로 보내고 그렇지 않다면 main.do로
        if (roles.contains("ROLE_ADMIN")) {
            response.sendRedirect("/admin.do");
        } else {
            response.sendRedirect("/main.do");
        }
        
    }
    
}
