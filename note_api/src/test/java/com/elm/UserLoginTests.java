package com.elm;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import com.elm.entity.UserEntity;
import com.elm.repository.UserRepository;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserLoginTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private UserRepository userRepository;

    @BeforeEach
    public void setUp() {
        userRepository.deleteAll();
    }

    @Test
    public void testLoginSuccess() {
        UserEntity newUser = new UserEntity(null, "loginuser", "password",
                "male", "Leo", "Reading", "INTP");
        restTemplate.postForEntity("/users", newUser, UserEntity.class);

        ResponseEntity<UserEntity> response = restTemplate.getForEntity("/users/search?username=loginuser&password=password",
                UserEntity.class);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertNotNull(response.getBody().getId());
    }

    @Test
    public void testLoginWrongUsername() {
        UserEntity newUser = new UserEntity(null, "testuser2", "password",
                "male", "Leo", "Reading", "INTP");
        restTemplate.postForEntity("/users", newUser, UserEntity.class);

        ResponseEntity<String> response = restTemplate.getForEntity("/users/search?username=wronguser&password=password",
                String.class);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().contains("用户不存在"));
    }

    @Test
    public void testLoginWrongPassword() {
        UserEntity newUser = new UserEntity(null, "loginuser2", "password2", "male",
                "Leo", "Reading", "INTP");
        restTemplate.postForEntity("/users", newUser, UserEntity.class);

        ResponseEntity<String> response = restTemplate.getForEntity("/users/search?username=loginuser2&password=wrongpassword",
                String.class);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().contains("用户不存在"));
    }
}
