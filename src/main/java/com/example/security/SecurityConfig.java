package com.example.security;

import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
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
	
	@Value("${security.rememberme.key}")
    private String rememberMeKey;
	
    @Autowired
    public SecurityConfig(BCryptPasswordEncoder bCryptPasswordEncoder) {
    	
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
			.antMatchers("/signup2.do").hasRole("SIGNUP")
			.antMatchers("/","signin.do","/signup.do","/signup_ok.do","/klogout.do","/kSignup_ok.do","/kakao.do","/idCheck.do",
					"/reset_password","/reset_password_ok","/findId","/findPw","/overlappingLogin.do",
					"/css/**","/fonts/**","/js/**","/sass/**","/style.css","/bundle.js","/img/**","/src/images/**").permitAll()
			.antMatchers("/admin.do","/adminAnnouncement.do","/boardManagement.do","/feedback.do","/feedback_view.do").hasRole("ADMIN")
			.anyRequest().authenticated();

		
		
		/*http.authorizeRequests()
		.anyRequest().permitAll();*/
		
		http.formLogin()
			.loginPage("/signin.do")
			.loginProcessingUrl("/signin_ok")
			.successHandler(successHandler)
			//.failureHandler(failureHandler)
			.failureUrl("/signin.do?error")
			.usernameParameter("id")
			.passwordParameter("password")
			.permitAll();
		http.logout()
			.logoutSuccessUrl("/")
			.permitAll()
			.and()
			// 로그인 상태 유지
			.rememberMe()
				.key(rememberMeKey)
				.userDetailsService(userDetailsService());
		
		/*http.sessionManagement()
	        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) // 세션 생성 정책
	        .invalidSessionUrl("/") // 세션이 유효하지 않을 때 리다이렉션 URL
	        .maximumSessions(1) // 동시에 사용할 수 있는 최대 세션 수. 이 경우, 1로 설정하므로 동일한 계정으로 한 번에 하나의 세션만 허용됩니다.
	        .expiredUrl("/");*/
			
			
		
		http.csrf().disable();
	}
	
	@Autowired
	private DataSource dataSource;
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(customUserDetailsService).passwordEncoder(bCryptPasswordEncoder);
	}
	
}
