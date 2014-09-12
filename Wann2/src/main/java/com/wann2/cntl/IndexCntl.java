package com.wann2.cntl;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.wann2.domain.Test;
import com.wann2.service.TestService;

@Controller
public class IndexCntl {

	@Autowired
	private TestService testService;

	@RequestMapping(value="/", method=RequestMethod.GET)
	public String index(Model model) {
		
		ArrayList<Test> listTest = testService.listTest();

		model.addAttribute("listTest", listTest);
		
		return "index";
		
	}
	
	@RequestMapping(value="/m", method=RequestMethod.GET)
	public String m(Model model) {
		
		ArrayList<Test> listTest = testService.listTest();

		model.addAttribute("listTest", listTest);
		
		return "mobile";
		
	}
	
}
