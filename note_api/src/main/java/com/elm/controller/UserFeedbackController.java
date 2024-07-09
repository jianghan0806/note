package com.elm.controller;

import com.elm.entity.UserFeedbackEntity;
import com.elm.service.UserFeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/feedbacks")
public class UserFeedbackController {

    private final UserFeedbackService userFeedbackService;

    @Autowired
    public UserFeedbackController(UserFeedbackService userFeedbackService) {
        this.userFeedbackService = userFeedbackService;
    }

    // 获取所有反馈
    @GetMapping
    public ResponseEntity<List<UserFeedbackEntity>> getAllFeedbacks() {
        List<UserFeedbackEntity> feedbacks = userFeedbackService.getAllFeedbacks();
        return ResponseEntity.ok(feedbacks);
    }

    // 根据ID获取单个反馈
    @GetMapping("/{id}")
    public ResponseEntity<UserFeedbackEntity> getFeedbackById(@PathVariable Long id) {
        UserFeedbackEntity feedback = userFeedbackService.getFeedbackById(id);
        return feedback != null ? ResponseEntity.ok(feedback) : ResponseEntity.notFound().build();
    }

    // 创建新的反馈
    @PostMapping
    public ResponseEntity<UserFeedbackEntity> createFeedback(@RequestBody UserFeedbackEntity feedback) {
        UserFeedbackEntity createdFeedback = userFeedbackService.saveFeedback(feedback);
        return ResponseEntity.ok(createdFeedback);
    }

    // 删除反馈
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFeedback(@PathVariable Long id) {
        userFeedbackService.deleteFeedback(id);
        return ResponseEntity.ok().build();
    }
}
