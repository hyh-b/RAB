package com.example.security;

import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import com.example.model.MemberDAO;
import com.example.model.MemberTO;

import ch.qos.logback.core.pattern.color.BoldCyanCompositeConverter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter{
	
	private final BCryptPasswordEncoder bCryptPasswordEncoder;
	
	@Autowired
	private CustomUserDetailsService customUserDetailsService;
	
	@Autowired
    private CustomAuthenticationSuccessHandler successHandler;
	
    @Autowired
    public SecurityConfig(BCryptPasswordEncoder bCryptPasswordEncoder) {
    	
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
			.antMatchers("/signup2.do").hasRole("SIGNUP")
			.antMatchers("/signup.do","/signup_ok.do","/kSignup_ok.do","/kakao.do","/idCheck.do","/reset_password","/reset_password_ok","/findId","/findPw",
					"/css/**","/fonts/**","/js/**","/sass/**","/style.css","/bundle.js","/img/**","/src/images/**").permitAll()
			.antMatchers("/admin.do","/adminAnnouncement.do","/boardManagement.do","/feedback.do").hasRole("ADMIN")
			.anyRequest().authenticated();

		
		
		/*http.authorizeRequests()
		.anyRequest().permitAll();*/
		
		http.formLogin()
			.loginPage("/signin.do")
			.loginProcessingUrl("/signin_ok")
			.successHandler(successHandler)
			.failureUrl("/signin.do?error")
			.usernameParameter("id")
			.passwordParameter("password")
			.permitAll();
		http.logout()
			.logoutSuccessUrl("/")
			.permitAll();
		
		http.csrf().disable();
	}
	
	@Autowired
	private DataSource dataSource;
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(customUserDetailsService).passwordEncoder(bCryptPasswordEncoder);
	}
	
}
