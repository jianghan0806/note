package com.elm;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import com.elm.entity.UserEntity;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserRegistrationTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testRegisterNewUser() {
        UserEntity newUser = new UserEntity(null, "testuser11", "password",
                "male", "Leo", "Reading", "INTP");
        HttpHeaders headers = new HttpHeaders();
        HttpEntity<UserEntity> request = new HttpEntity<>(newUser, headers);
        ResponseEntity<String> response = restTemplate.exchange("/users", HttpMethod.POST, request, String.class);

        assertEquals(200, response.getStatusCodeValue());
        assertTrue(response.getBody().contains("\"id\":"));
    }

    @Test
    public void testRegisterDuplicateUsername() {
        UserEntity newUser = new UserEntity(null, "duplicateuser", "password", "male",
                "Leo", "Reading", "INTP");
        HttpHeaders headers = new HttpHeaders();
        HttpEntity<UserEntity> request = new HttpEntity<>(newUser, headers);
        restTemplate.exchange("/users", HttpMethod.POST, request, String.class);
        ResponseEntity<String> response = restTemplate.exchange("/users", HttpMethod.POST, request, String.class);

        assertEquals(400, response.getStatusCodeValue());
        assertTrue(response.getBody().contains("用户名已存在"));
    }
}
