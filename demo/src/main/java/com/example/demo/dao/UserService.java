package com.example.demo.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.mapper.UserMapper;
import com.example.demo.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {
	@Autowired
	UserMapper userMapper;
	
	// 3 비밀번호 해시 객체 생성
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	HttpSession session;

//	서비스는 비즈니스 로직이니까 사용자 초점에 맞게 login으로 명명
	public HashMap<String, Object> login(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>(); 
		try {
			User user =userMapper.selectUser(map);
			if(user != null) {
				// 아이디는 검색 성공
				Boolean login = passwordEncoder.matches((String) map.get("pwd"), user.getPwd());
				// 첫번째 있는 값을 해시화 해서 두번째 값과 비교해주는 함수
				if(login) {
					session.setAttribute("sessionId", user.getUserId()); // 로그인할 때 권한도 넣어줘야 함
					session.setAttribute("sessionName", user.getUserName()); 
					session.setAttribute("sessionRole", user.getRole());
					// 관리자 로그인 -> product/list.do 
					// 유저 로그인 -> board/list.do
					if(user.getRole().equals("A")) {
						resultMap.put("url", "/product/list.do");
					}else {
						resultMap.put("url", "/board/list.do");
					}
					
//					session.getMaxInactiveInterval(); // 세션 유지시간 
					//session.invalidate(); // 로그아웃 시 세션에 있는 모든 데이터 삭제
					
					user.getPwd();
					resultMap.put("loginFlg", true);
					resultMap.put("message", user.getUserName()+"님 환영합니다.");
				}else {
					resultMap.put("loginFlg", false);
					resultMap.put("message", Message.LOGIN_FAIL);
				}
				// public getter 메소드로 이름 갖고오기 가능!
			}else {
				// 아이디가 없는 경우
				resultMap.put("loginFlg", false);
				resultMap.put("message", Message.LOGIN_FAIL);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		
		try {
			String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
			System.out.println("해시 전 패스워드 => " + map.get("pwd"));
			System.out.println("해시 후 패스워드 => " + hashPwd);
			map.put("hashPwd", hashPwd);
			userMapper.insertUser(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "success");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> editUserPwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
			map.put("hashPwd", hashPwd);
			userMapper.updateUserPwd(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "success");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getUserAuth(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int result = userMapper.selectUserAuth(map);
			if(result > 0) {
				resultMap.put("success", true);
				resultMap.put("message", "인증되었습니다.");
			}else{
				resultMap.put("success", false);
				resultMap.put("message", "인증에 실패했습니다. 아이디를 확인해주세요.");
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "false");
			System.out.println(e.getMessage());
		}
		return resultMap;
	} 
}
