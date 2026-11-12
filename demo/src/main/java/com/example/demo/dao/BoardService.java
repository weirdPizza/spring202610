package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.mapper.BoardMapper;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;
import com.example.demo.model.File;

import jakarta.servlet.http.HttpSession;

@Service
public class BoardService {
	@Autowired
	BoardMapper	boardMapper; 
	
	@Autowired
	HttpSession session;
	
	public HashMap<String, Object> getBoardList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>(); 
		try {
			// object -> 문자열 -> 숫자 이렇게 변환을 해줘야 함... object -> 숫자가 바로 안됨..주의
			String limit = (String) map.get("limit");
			String offset = (String) map.get("offset");
			map.put("limit", Integer.parseInt(limit));
			map.put("offset", Integer.parseInt(offset));
			
			List<Board> list =boardMapper.selectBoardList(map);
			int count = boardMapper.selectBoardCount(map);
			resultMap.put("list", list);
			resultMap.put("count", count);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.err.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getBoard(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>(); 
		try {
			Board info =boardMapper.selectBoard(map);
			
			// getBoard는 상세정보보기 뿐 아니라 편집 시 불러오기 시 사용됨.
			// 근데 댓글목록은 편집 시 필요가 없음.
			// 이런 게 많아지면 당연히 서버에 부담이 갈 수 밖에 없음.
			// => 예외 처리 해야.
			// 상세보기 화면에서만 댓글 목록 가져오기
			if(map.get("option").equals("VIEW")) {
				List<Comment> cmtList = boardMapper.selectCmt(map);
				resultMap.put("cmtList", cmtList);				
			}
			
			List<File> fileList = boardMapper.selectBoardFile(map);
			resultMap.put("info", info);
			resultMap.put("fileList", fileList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.err.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> removeBoard(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = boardMapper.deleteBoard(map);
			resultMap.put("result", "success");	
			if(cnt > 0) {
				resultMap.put("message", Message.DELETE_SUCCESS);
			}else {
				resultMap.put("message", Message.DELETE_FAIL);				
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> removeBoardAll(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = boardMapper.deleteBoardAll(map);
			resultMap.put("result", "success");	
			if(cnt > 0) {
				resultMap.put("message", Message.DELETE_SUCCESS);
			}else {
				resultMap.put("message", Message.DELETE_FAIL);				
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addBoard(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			
			if(session.getAttribute("sessionId") != null) {
				map.put("sessionId", session.getAttribute("sessionId"));
				int cnt = boardMapper.insertBoard(map);
				System.out.println(map);
				resultMap.put("result", "success");	
				resultMap.put("boardNo", map.get("boardNo"));
				if(cnt > 0) {
					resultMap.put("message", Message.INSERT_SUCCESS);
				}else {
					resultMap.put("message", Message.INSERT_FAIL);				
				}
			}else {
				resultMap.put("message", "세션이 만료되었습니다.");
				resultMap.put("result", "fail");
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> editBoard(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = boardMapper.updateBoard(map);
			resultMap.put("result", "success");	

		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addBoardFile(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = boardMapper.insertBoardFile(map);
			resultMap.put("result", "success");	
			if(cnt > 0) {
				resultMap.put("message", Message.INSERT_SUCCESS);
			}else {
				resultMap.put("message", Message.INSERT_FAIL);				
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		return resultMap;
	}

	public void editCnt(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		boardMapper.updateCnt(map);
	}

	public HashMap<String, Object> addCmt(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("result", "success");	
			if(session.getAttribute("sessionId") != null) {
				map.put("sessionId", session.getAttribute("sessionId"));
				int cnt = boardMapper.insertCmt(map);
				System.out.println(map);
				resultMap.put("result", "success");	
				if(cnt > 0) {
					resultMap.put("message", Message.INSERT_SUCCESS);
				}else {
					resultMap.put("message", Message.INSERT_FAIL);				
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> editCmt(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {

			if(session.getAttribute("sessionId") != null) {
				map.put("sessionId", session.getAttribute("sessionId"));
				int cnt = boardMapper.updateCmt(map);
				System.out.println(map);
				resultMap.put("result", "success");	
				resultMap.put("boardNo", map.get("boardNo"));
				if(cnt > 0) {
					resultMap.put("message", Message.UPDATE_SUCCESS);
				}else {
					resultMap.put("message", Message.UPDATE_FAIL);				
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		
		return resultMap;
	
	}

	public HashMap<String, Object> removeCmt(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("result", "success");	
			if(session.getAttribute("sessionId") != null) {
				map.put("sessionId", session.getAttribute("sessionId"));
				int cnt = boardMapper.deleteCmt(map);
				System.out.println(map);
				resultMap.put("result", "success");	
				if(cnt > 0) {
					resultMap.put("message", Message.DELETE_SUCCESS);
				}else {
					resultMap.put("message", Message.DELETE_FAIL);				
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		return resultMap;
	}

}
