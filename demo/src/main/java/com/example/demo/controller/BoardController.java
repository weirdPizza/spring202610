package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.BoardService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class BoardController {
	@Autowired
	BoardService boardService; 
	
	// 목록 페이지
	@RequestMapping("/board/list.do") 
	public String test(Model model) throws Exception{

		return "/board/list";
	} 
	
	@RequestMapping(value = "/board/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = boardService.getBoardList(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/board/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = boardService.removeBoard(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/board/remove-all.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeAll(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String json = (String)map.get("selectItemList");
		// 이 상태에서 json에 들어온 값은 "[14, 15, 20]" 리스트가 아니라 문자열임. 그래서 반복문 돌려서 처리하고 싶어도 그러지 못함.
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {});
		// 위 2줄로 문자열을 리스트로 바꿀 수 있음. (이건 외우지말고 복사) 
		
		map.put("list", list);
		System.out.println(map);

		resultMap = boardService.removeBoardAll(map);
		
		return new Gson().toJson(resultMap); 
	}
}
