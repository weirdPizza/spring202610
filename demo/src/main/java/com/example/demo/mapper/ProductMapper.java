package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.File;
import com.example.demo.model.Product;

@Mapper
public interface ProductMapper {
	// 제품 목록
	List<Product> selectProductList(HashMap<String, Object> map);
	
	//카테고리 목록
	List<Product> selectCategoryList(HashMap<String, Object> map);
	
	// 제품 상세정보
	Product selectProduct(HashMap<String, Object> map);

	// 제품 제거
	int deleteProduct(HashMap<String, Object> map);

	// 제품 추가
	int insertProduct(HashMap<String, Object> map);

	// 첨부파일 목록에 추가
	int insertProductFile(HashMap<String, Object> map);
	
	// 첨부파일 목록
	List<File> selectProductFile(HashMap<String, Object> map);

	// 결제 정보 추가
	int insertPayment(HashMap<String, Object> map);
}
