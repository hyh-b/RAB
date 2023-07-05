package com.example.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        // Retrieve the authenticated user details
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        // Store the user details in the session
        HttpSession session = request.getSession();
        session.setAttribute("userDetails", userDetails);

        // Redirect to a success URL or perform any additional actions
        response.sendRedirect("/home");
    }
}
