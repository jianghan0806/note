package com.elm.service;

import com.elm.entity.NoteEntity;
import com.elm.repository.NoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NoteService {
    private final NoteRepository noteRepository;

    @Autowired
    public NoteService(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    public List<NoteEntity> findAllNotes() {
        return noteRepository.findAll();
    }

    public NoteEntity addNote(NoteEntity note) {
        return noteRepository.save(note);
    }

    public NoteEntity updateNote(Integer id, NoteEntity note) {
        note.setId(id);
        return noteRepository.save(note);
    }

    public void deleteNote(Integer id) {
        noteRepository.deleteById(id);
    }

    public Optional<NoteEntity> findNoteById(Integer id) {
        return noteRepository.findById(id);
    }

    public List<NoteEntity> findNotesByUserId(Integer userId) {
        return noteRepository.findByUserId(userId);
    }

    public List<NoteEntity> findNotesByKeywordAndUserId(String keyword, Integer userId) {
        return noteRepository.findByUserIdAndTitleContainingOrContentContaining(userId, keyword, keyword);
    }

    public List<NoteEntity> findNotesByUserIdAndStar(Integer userId, Integer star) {
        return noteRepository.findByUserIdAndStar(userId, star);
    }

    public void updateNoteStarById(Integer id, Integer star) {
        Optional<NoteEntity> note = noteRepository.findById(id);
        if (note.isPresent()) {
            NoteEntity existingNote = note.get();
            existingNote.setStar(star);
            noteRepository.save(existingNote);
        }
    }
}
