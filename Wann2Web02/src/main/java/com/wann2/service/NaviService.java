package com.wann2.service;

import java.util.ArrayList;
import com.wann2.domain.Navi;

public interface NaviService {
	
	public ArrayList<Navi> listNavi();
	
	public String getAddr(String mapType);
	
}