package com.elm.repository;

import com.elm.entity.UserFeedbackEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserFeedbackRepository extends JpaRepository<UserFeedbackEntity, Long> {
    // Custom query methods if needed
}
