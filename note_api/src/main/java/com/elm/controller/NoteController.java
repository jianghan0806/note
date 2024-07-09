package com.elm.controller;

import com.elm.entity.NoteEntity;
import com.elm.service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/notes")
public class NoteController {

    private final NoteService noteService;

    @Autowired
    public NoteController(NoteService noteService) {
        this.noteService = noteService;
    }

    // 获取所有Note
    @GetMapping
    public ResponseEntity<List<NoteEntity>> getAllNotes() {
        List<NoteEntity> notes = noteService.findAllNotes();
        return ResponseEntity.ok(notes);
    }

    // 根据ID获取单个Note
    @GetMapping("/{id}")
    public ResponseEntity<NoteEntity> getNoteById(@PathVariable Integer id) {
        Optional<NoteEntity> note = noteService.findNoteById(id);
        return note.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    // 创建新的Note
    @PostMapping
    public ResponseEntity<NoteEntity> createNote(@RequestBody NoteEntity note) {
        NoteEntity createdNote = noteService.addNote(note);
        return ResponseEntity.ok(createdNote);
    }

    // 更新现有的Note
    @PutMapping("/{id}")
    public ResponseEntity<NoteEntity> updateNote(@PathVariable Integer id, @RequestBody NoteEntity note) {
        NoteEntity updatedNote = noteService.updateNote(id, note);
        if (updatedNote == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updatedNote);
    }

    // 删除Note
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNote(@PathVariable Integer id) {
        noteService.deleteNote(id);
        return ResponseEntity.ok().build();
    }

    // 根据userId获取Notes
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<NoteEntity>> getNotesByUserId(@PathVariable Integer userId) {
        List<NoteEntity> notes = noteService.findNotesByUserId(userId);
        return ResponseEntity.ok(notes);
    }

    // 根据关键词和userId获取Notes
    @GetMapping("/search")
    public ResponseEntity<List<NoteEntity>> getNotesByKeywordAndUserId(@RequestParam String keyword, @RequestParam Integer userId) {
        List<NoteEntity> notes = noteService.findNotesByKeywordAndUserId(keyword, userId);
        return ResponseEntity.ok(notes);
    }

    // 根据userId和star状态获取Notes
    @GetMapping("/star")
    public ResponseEntity<List<NoteEntity>> getNotesByUserIdAndStar(@RequestParam Integer userId, @RequestParam Integer star) {
        List<NoteEntity> notes = noteService.findNotesByUserIdAndStar(userId, star);
        return ResponseEntity.ok(notes);
    }

    // 更新Note的star状态
    @PatchMapping("/{id}/star")
    public ResponseEntity<Void> updateNoteStarById(@PathVariable Integer id, @RequestParam Integer star) {
        noteService.updateNoteStarById(id, star);
        return ResponseEntity.ok().build();
    }
}
