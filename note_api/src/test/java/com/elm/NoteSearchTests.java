package com.elm;

import static org.junit.jupiter.api.Assertions.*;

import com.elm.entity.NoteEntity;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.util.Arrays;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class NoteSearchTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testSearchNote() {
        NoteEntity newNote = new NoteEntity(null, 1, "Searchable Title", "Content",
                System.currentTimeMillis(), 0, 0, 1);
        ResponseEntity<NoteEntity> createResponse = restTemplate.postForEntity("/notes", newNote, NoteEntity.class);
        assertEquals(HttpStatus.OK, createResponse.getStatusCode());

        NoteEntity createdNote = createResponse.getBody();
        assertNotNull(createdNote);
        assertNotNull(createdNote.getId());

        ResponseEntity<NoteEntity[]> response = restTemplate.getForEntity("/notes/search?keyword=Searchable&userId=1",
                NoteEntity[].class);
        assertEquals(HttpStatus.OK, response.getStatusCode());

        NoteEntity[] notes = response.getBody();
        assertNotNull(notes);
        assertTrue(notes.length > 0);

        boolean found = Arrays.stream(notes).anyMatch(note -> note.getTitle().contains("Searchable"));
        assertTrue(found, "The note with the title 'Searchable Title' should be found in the search results.");
    }

    @Test
    public void testSearchNoteNotFound() {
        ResponseEntity<NoteEntity[]> response = restTemplate.getForEntity("/notes/search?keyword=NonExistent&userId=1",
                NoteEntity[].class);
        assertEquals(HttpStatus.OK, response.getStatusCode());

        NoteEntity[] notes = response.getBody();
        assertNotNull(notes);
        assertEquals(0, notes.length);
    }
}
