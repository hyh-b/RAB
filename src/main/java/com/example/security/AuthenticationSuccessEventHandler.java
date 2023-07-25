package com.example.security;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.InteractiveAuthenticationSuccessEvent;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationSuccessEventHandler implements ApplicationListener<InteractiveAuthenticationSuccessEvent> {
	@Autowired
    private HttpSession httpSession;

    @Override
    public void onApplicationEvent(InteractiveAuthenticationSuccessEvent event) {
        String access_token = (String) httpSession.getAttribute("access_token");

        // 로그인 후에 새롭게 만들어진 세션에 이전에 저장해둔 accessToken을 넣는다.
        SecurityContextHolder.getContext().setAuthentication(event.getAuthentication());
        httpSession.setAttribute("access_token", access_token);
    }
}

