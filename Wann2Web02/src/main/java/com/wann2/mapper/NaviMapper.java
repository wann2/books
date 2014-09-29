package com.wann2.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import com.wann2.domain.Navi;

public interface NaviMapper {
	
	public ArrayList<Navi> listNavi();
	
	public String getAddr(HashMap<String, String> hashmap);
	
}