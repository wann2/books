package com.wann2.service;

import java.util.ArrayList;

import com.wann2.domain.Test;
import com.wann2.mapper.TestMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

@Service("CommCodeService")
@Repository
public class TestServiceImpl implements TestService {
	
	@Autowired
	private TestMapper testMapper;
	

	public ArrayList<Test> listTest() {
		
		return testMapper.listTest();
	}
	
	
	
}
