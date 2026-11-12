package com.example.demo.model;

import lombok.Data;

@Data
public class Comment {
	private String commentNo;
	private String boardNo;
	private String pCommentNo;
	private String contents;
	private String userId;
	private String cDateTime;
	private String uDateTime;
//	보통 조인관계끼리는 한 곳에서 작성 많이들 하심.
	// 그래서 이 comment 모델도 board 모델에 써도 됨ㅇㅇ 근데 따로 떼어도 ㄱㅊ
}
