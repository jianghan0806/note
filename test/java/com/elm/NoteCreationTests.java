package com.elm;
import static org.junit.jupiter.api.Assertions.*;

import com.elm.entity.NoteEntity;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class NoteCreationTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testCreateNote() {
        NoteEntity newNote = new NoteEntity(null, 1, "Title", "Content",
                System.currentTimeMillis(), 0, 0, 1);
        ResponseEntity<NoteEntity> response = restTemplate.postForEntity("/notes", newNote, NoteEntity.class);
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody().getId());
    }
    @Test
    public void testEditNote() {
        NoteEntity newNote = new NoteEntity(null, 1, "Title", "Content",
                System.currentTimeMillis(), 0, 0, 1);
        ResponseEntity<NoteEntity> createResponse = restTemplate.postForEntity("/notes", newNote, NoteEntity.class);
        NoteEntity createdNote = createResponse.getBody();

        createdNote.setTitle("Updated Title");
        restTemplate.put("/notes/" + createdNote.getId(), createdNote);

        ResponseEntity<NoteEntity> response = restTemplate.getForEntity("/notes/" + createdNote.getId(), NoteEntity.class);
        assertEquals(200, response.getStatusCodeValue());
        assertEquals("Updated Title", response.getBody().getTitle());
    }
    @Test
    public void testDeleteNote() {
        NoteEntity newNote = new NoteEntity(null, 1, "Title", "Content", System.currentTimeMillis(),
                0, 0, 1);
        ResponseEntity<NoteEntity> createResponse = restTemplate.postForEntity("/notes", newNote, NoteEntity.class);
        NoteEntity createdNote = createResponse.getBody();

        restTemplate.delete("/notes/" + createdNote.getId());

        ResponseEntity<String> response = restTemplate.getForEntity("/notes/" + createdNote.getId(), String.class);
        assertEquals(404, response.getStatusCodeValue());
    }
}
