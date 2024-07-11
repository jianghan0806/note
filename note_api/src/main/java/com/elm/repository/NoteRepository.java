package com.elm.repository;

import com.elm.entity.NoteEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NoteRepository extends JpaRepository<NoteEntity, Integer> {
    List<NoteEntity> findByUserId(Integer userId);
    List<NoteEntity> findByUserIdAndTitleContainingOrContentContaining(Integer userId, String titleKeyword, String contentKeyword);
    List<NoteEntity> findByUserIdAndStar(Integer userId, Integer star);
}
