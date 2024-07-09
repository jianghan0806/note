package com.elm;

import com.elm.pojo.Business;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class PoJoTest {
    Business bu =new Business();
    @Test
    public void Test(){
        String result = bu.toString();
        System.out.println();
    }
}
