package com.example.security;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import ch.qos.logback.core.pattern.color.BoldCyanCompositeConverter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter{
	
	private final BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    public SecurityConfig(BCryptPasswordEncoder bCryptPasswordEncoder) {
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }
	//@Autowired
    //private CustomAuthenticationSuccessHandler authenticationSuccessHandler;
    
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
		//.antMatchers("/profile.do").hasAnyRole("manage")
		.anyRequest().permitAll();
		/*.antMatchers("/","/signup.do","/signup_ok.do","kakao.do").permitAll()
			.antMatchers("/css/**","/fonts/**","/js/**","/sass/**","/style.css","/bundle.js","/src/images/**").permitAll()
			.anyRequest().authenticated();
			
		
		http.authorizeRequests()
		
		.anyRequest().permitAll();
		*/
		http.formLogin()
			.loginPage("/signin.do")
			.loginProcessingUrl("/signin_ok")
			.defaultSuccessUrl("/main.do",true)
			.failureUrl("/signin.do?error")
			.usernameParameter("id")
			.passwordParameter("password")
			.permitAll();
			//.successHandler(authenticationSuccessHandler);
		http.logout()
			
			.logoutSuccessUrl("/klogout.do")
			.permitAll();
		
		http.csrf().disable();
	}
	
	
	@Autowired
	private DataSource dataSource;
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		
		auth.jdbcAuthentication()
			.dataSource(dataSource)
			.usersByUsernameQuery("select m_id as username, m_pw as password, true as enabled from Member where m_id = ?")
            .authoritiesByUsernameQuery("select m_id as username, 'm_role' as authority from Member where m_id = ?")
			.passwordEncoder(new BCryptPasswordEncoder());
	}
	
}
