package com.elm;
import static org.junit.jupiter.api.Assertions.*;

import com.elm.entity.UserFeedbackEntity;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserFeedbackTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testSubmitFeedback() {
        UserFeedbackEntity feedback = new UserFeedbackEntity(null, 1L, "This is a feedback", System.currentTimeMillis());
        ResponseEntity<UserFeedbackEntity> response = restTemplate.postForEntity("/feedbacks", feedback, UserFeedbackEntity.class);
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody().getId());
    }
}

