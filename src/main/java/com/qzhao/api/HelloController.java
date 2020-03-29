package com.qzhao.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by zhao on 12/6/17.
 */

@RestController
public class HelloController {
    @GetMapping("/")

    public String home() {

        return "Qingjie Zhao - 1.0.0";
    }


}
