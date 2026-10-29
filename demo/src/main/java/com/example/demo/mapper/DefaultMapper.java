package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.User;

@Mapper
public interface DefaultMapper {
	List<User> selectUserList(); // 추상메소드여야 함. 인터페이스니까
	// 리턴 타입은 우리가 만든 User 클래스임.
	// select문이 여러결과를 반환하니까 List로 묶어줌. 만약 pk where절이라면 걍 User 여도 ㄱㅊ
	
	// 삭제 -> 리턴형이 삭제 몇개 됐나(int) 또는 void로 받아도 됨.
	void deleteUser(HashMap<String, Object> map);
	// map은 서비스로부터 온 거지.
}
