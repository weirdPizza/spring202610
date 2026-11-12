package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ChartMapper;
import com.example.demo.model.Chart;

@Service
public class ChartService {
	@Autowired
	ChartMapper chartMapper;

	public HashMap<String, Object> getChartList() { // selectUserList라 이름짓지 않은 이유는 mapper랑 혼동하지 않기 위해
		HashMap<String, Object> resultMap = new HashMap<>();
		List<Chart> list = chartMapper.selectChartList();
		Chart total = chartMapper.selectChartTotal();
		
		resultMap.put("list", list);
		resultMap.put("total", total);
		resultMap.put("result", "success");
		return resultMap;
	}	
}
