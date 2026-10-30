package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Emp;
@Mapper
public interface EmpMapper {
	// 사원 목록
	List<Emp> selectEmpList(HashMap<String, Object> map);
	
	// 사원 검색
	Emp selectEmp(HashMap<String, Object> map); 
	
	// 사원 삭제
	int deleteEmp(HashMap<String, Object> map);

	// 사원 추가
	int insertEmp(HashMap<String, Object> map);

	// 급여등급 목록
	List<Emp> selectGradeList(HashMap<String, Object> map);
}
