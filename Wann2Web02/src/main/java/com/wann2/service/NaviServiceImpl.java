package com.wann2.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.wann2.domain.Navi;
import com.wann2.mapper.NaviMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

@Service("NaviService")
@Repository
public class NaviServiceImpl implements NaviService {
	
	@Autowired
	private NaviMapper naviMapper;
	
	public ArrayList<Navi> listNavi() {
		
		return naviMapper.listNavi();
	}
	
	public String getAddr(String mapType) {
		
		HashMap<String, String> hashmap = new HashMap<String, String>();
		hashmap.put("mapType", mapType);
		
		return naviMapper.getAddr(hashmap);
	}

}
