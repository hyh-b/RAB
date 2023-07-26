package com.example.security;

import org.springframework.security.access.AccessDecisionVoter;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.FilterInvocation;

import java.util.Collection;

public class RestrictAdminAccessVoter implements AccessDecisionVoter<FilterInvocation> {

    @Override
    public boolean supports(ConfigAttribute attribute) {
        return true;
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return FilterInvocation.class.isAssignableFrom(clazz);
    }

    @Override
    public int vote(Authentication authentication, FilterInvocation object, Collection<ConfigAttribute> attributes) {
        String url = object.getRequestUrl();
        if (url.startsWith("/main.do") || url.startsWith("/exercise.do") || url.startsWith("/food.do") 
        		|| url.startsWith("/profile.do")|| url.startsWith("/notice_board.do")|| url.startsWith("/board_list1.do")) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                if (authority.getAuthority().equals("ROLE_ADMIN")) {
                    return ACCESS_DENIED;
                }
            }
        }
        return ACCESS_GRANTED;
    }
}
