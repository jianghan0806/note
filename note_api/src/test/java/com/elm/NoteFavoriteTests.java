package com.elm;

import static org.junit.jupiter.api.Assertions.*;

import com.elm.entity.NoteEntity;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class NoteFavoriteTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testFavoriteNote() {
        NoteEntity newNote = new NoteEntity(null, 1, "Title", "Content", System.currentTimeMillis(),
                0, 0, 1);
        ResponseEntity<NoteEntity> createResponse = restTemplate.postForEntity("/notes", newNote, NoteEntity.class);
        NoteEntity createdNote = createResponse.getBody();

        restTemplate.patchForObject("/notes/" + createdNote.getId() + "/star?star=1", null, Void.class);

        ResponseEntity<NoteEntity> response = restTemplate.getForEntity("/notes/" + createdNote.getId(), NoteEntity.class);
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(1, response.getBody().getStar());
    }

    @Test
    public void testUnfavoriteNote() {
        NoteEntity newNote = new NoteEntity(null, 1, "Title", "Content", System.currentTimeMillis(),
                1, 0, 1);
        ResponseEntity<NoteEntity> createResponse = restTemplate.postForEntity("/notes", newNote, NoteEntity.class);
        NoteEntity createdNote = createResponse.getBody();

        restTemplate.patchForObject("/notes/" + createdNote.getId() + "/star?star=0", null, Void.class);

        ResponseEntity<NoteEntity> response = restTemplate.getForEntity("/notes/" + createdNote.getId(), NoteEntity.class);
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(0, response.getBody().getStar());
    }
}
