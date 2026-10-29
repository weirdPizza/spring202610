package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.DefaultService;
import com.google.gson.Gson;

@Controller
public class DefaultController {
	// 서비스 객체 만들어줌. (Autowired로!)
	@Autowired
	DefaultService defaultService;
	
//	컨트롤러에 "/default.do" 이 주소 만들어둠. 우린 이 url 로 접속 가능함.
	@RequestMapping("/default.do") // Requestmapping 주소를 만들어주고 들어오면 return을 실행해준다.
	public String test(Model model) throws Exception{
		// System.out.println("Hello");
		// /default.do 란 주소 들어오면 /qqq(application.properties 명시된 대로 WEB-INF 아래 위치) 란 파일 띄울게란 의미
		return "/test";
	} //.do는 jsp파일 연결
	
	// .dox는 비즈니스 로직 연결
	@RequestMapping(value = "/default.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("dox 호출!");
		
		resultMap = defaultService.getUserList();
		
		return new Gson().toJson(resultMap); // json 형태로 바꿔 리턴해야. 
	}
	
	@RequestMapping(value = "/stu-remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap = defaultService.removeUser(map);
		
		return new Gson().toJson(resultMap); // json 형태로 바꿔 리턴해야. 
	}
	
}
