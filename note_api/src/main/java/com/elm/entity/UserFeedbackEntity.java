package com.elm.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "user_feedback")
public class UserFeedbackEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private String feedback;

    @Column(nullable = false)
    private Long timestamp;

    // 无参构造函数
    public UserFeedbackEntity() {}

    // 全参构造函数
    public UserFeedbackEntity(Long id, Long userId, String feedback, Long timestamp) {
        this.id = id;
        this.userId = userId;
        this.feedback = feedback;
        this.timestamp = timestamp;
    }

    // Getter 和 Setter 方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }
}
