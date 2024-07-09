package com.elm.service;

import com.elm.entity.UserFeedbackEntity;
import com.elm.repository.UserFeedbackRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserFeedbackService {

    private final UserFeedbackRepository userFeedbackRepository;

    @Autowired
    public UserFeedbackService(UserFeedbackRepository userFeedbackRepository) {
        this.userFeedbackRepository = userFeedbackRepository;
    }

    public List<UserFeedbackEntity> getAllFeedbacks() {
        return userFeedbackRepository.findAll();
    }

    public UserFeedbackEntity getFeedbackById(Long id) {
        return userFeedbackRepository.findById(id).orElse(null);
    }

    public UserFeedbackEntity saveFeedback(UserFeedbackEntity feedback) {
        return userFeedbackRepository.save(feedback);
    }

    public void deleteFeedback(Long id) {
        userFeedbackRepository.deleteById(id);
    }
}
