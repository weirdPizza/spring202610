package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ProfessorMapper;
import com.example.demo.model.Professor;

@Service
public class ProfessorService {
	@Autowired
	ProfessorMapper professorMapper;
	
	public HashMap<String, Object> getProfessorList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>(); 
		
		String limit = (String) map.get("limit"); // 받은 맵에서 문자열로 꺼내
		String offset = (String) map.get("offset");
		map.put("limit", Integer.parseInt(limit)); // 쿼리를 향한 전달은 정수로
		map.put("offset", Integer.parseInt(offset)); // map은 쿼리로 보내는 용임!!! 그래서 이렇게 넣어주고 쿼리 수행해야함 (순서 1)
		
		int count = professorMapper.selectProfessorCount(map); // 이건 count 쿼리
		resultMap.put("count", count); // 아작스로 보내는 용
		
		List<Professor> list =professorMapper.selectProfessorList(map); // (순서 2)
		List<Professor> deptList = professorMapper.selectDeptList(map);
		List<Professor> positionList = professorMapper.selectPositionList(map);
		
		resultMap.put("list", list);
		resultMap.put("deptList", deptList);
		resultMap.put("positionList", positionList);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> getProfessor(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>(); 
		Professor info =professorMapper.selectProfessor(map);
//		쌤은 데이터 1개짜리는 info란 이름을 많이 쓰신대
		resultMap.put("info", info);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> removeProfessor(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		professorMapper.deleteProfessor(map);
		
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> addProfessor(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		professorMapper.insertProfessor(map);
		
		resultMap.put("result", "success");
		return resultMap;
	}
	
	
	public HashMap<String, Object> getDeptList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>(); 
		List<Professor> deptList =professorMapper.selectDeptList(map);
		resultMap.put("deptList", deptList);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> editProfessor(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();		
		try {
			professorMapper.updateProfessor(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
}
