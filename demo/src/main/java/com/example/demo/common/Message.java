package com.example.demo.common;

public class Message {
	public static final String DB_ERR = "에러가 발생했습니다. 나중에 다시 시도해주세요.";
	// final 을 붙이면 누구도 수정 못하고 접근 가능해짐. 
	public static final String LOGIN_SUCCESS = "로그인에 성공 하셨습니다.";
	public static final String LOGIN_FAIL = "아이디/비밀번호를 확인해주세요.";
	
	public static final String LIST_SUCCESS = "목록을 조회했습니다.";
	public static final String LIST_FAIL = "목록 조회에 실패했습니다.";
	
//	사실 static은 대문자로 해야함!!!!
	public static final String DELETE_SUCCESS = "삭제되었습니다.";
	public static final String DELETE_FAIL = "삭제에 실패했습니다. 나중에 다시 시도해주세요.";
	
	public static final String INSERT_SUCCESS = "등록되었습니다.";
	public static final String INSERT_FAIL = "등록에 실패했습니다. 나중에 다시 시도해주세요.";
	
	public static final String UPDATE_SUCCESS = "수정되었습니다.";
	public static final String UPDATE_FAIL = "수정에 실패했습니다. 나중에 다시 시도해주세요.";
}
