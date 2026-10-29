package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.DefaultMapper;
import com.example.demo.model.User;

@Service // Mapper는 인터페이스여서 원래 선언만으로 호출할 수 없지만 어노테이션을 통해 가능하게 해줌.
public class DefaultService {
 // 비즈니스 로직
	
	@Autowired
	DefaultMapper defaultMapper;
	// 근데 매번 쿼리마다 선언하면 귀찮으니까 이 Autowired를 통해 자동으로 호출?해줌.
	// 우리끼리의 약속 : Autowired로 객체를 만들 때 해당 클래스 이름 그대로. 첫글자만 소문자로 바꿔서
	
	public HashMap<String, Object> getUserList() { // selectUserList라 이름짓지 않은 이유는 mapper랑 혼동하지 않기 위해
		HashMap<String, Object> resultMap = new HashMap<>();
		List<User> list = defaultMapper.selectUserList();
		
		resultMap.put("list", list);
		resultMap.put("result", "success");
		return resultMap;
	}	
	
//	get, remove, edit, add => 서비스에서 쓰는 이름으로 사용하고
//	select, delete, update, insert => mapper, xml(쿼리)에서 쓰는 이름으로 사용
	// 이런식으로 구분하면 함수 이름만 보고 어느 로직인지 구분 쉽게 가능
	
	public HashMap<String, Object> removeUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		defaultMapper.deleteUser(map);
		
		resultMap.put("result", "success");
		return resultMap;
	}
}
