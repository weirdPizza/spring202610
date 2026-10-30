package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.EmpMapper;
import com.example.demo.model.Emp;
import com.example.demo.model.Professor;
@Service
public class EmpService {
	@Autowired
	EmpMapper empMapper;
	
	public HashMap<String, Object> getEmpList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		List<Emp> list = empMapper.selectEmpList(map);
		
		List<Emp> gradeList =empMapper.selectGradeList(map);
		resultMap.put("gradeList", gradeList);
		
		resultMap.put("list", list);
		resultMap.put("result", "success");
		return resultMap;
	}	
	
	public HashMap<String, Object> removeEmp(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		empMapper.deleteEmp(map);
		
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> addEmp(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			empMapper.insertEmp(map);
			// 데베 접근 과정에서 에러 발생할 수 있으니 try 문 안에 넣음
			// 위에서 오류 발생하면 밑의 success 까지 도달 전에 catch 문으로 이동하겠죠?
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.err.println(e.getMessage());
			// catch에서 꼭! e.getMessage()가 있어야 에러 원인을 띄워줌 (개발자가 보기 위한 System으로)
		}
		return resultMap;
	}

	public HashMap<String, Object> getEmp(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap();
		try {
			Emp info = empMapper.selectEmp(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.err.println(e.getMessage());
		}
		return resultMap;
	}
	
	
}
