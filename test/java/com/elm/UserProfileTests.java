package com.elm;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;
import com.elm.entity.UserEntity;
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserProfileTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testViewUserProfile() {
        ResponseEntity<UserEntity> response = restTemplate.getForEntity("/users/55", UserEntity.class);
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody().getUsername());
    }
}

