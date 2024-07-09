package com.elm.service;
import com.elm.entity.TodoEntity;
import com.elm.repository.TodoRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TodoService {

    private final TodoRepository todoRepository;

    @Autowired
    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public List<TodoEntity> findAllTodos() {
        return todoRepository.findAll();
    }

    public TodoEntity addTodo(TodoEntity todo) {
        // 默认新添加的Todo项未完成
        todo.setIsDone(false);
        return todoRepository.save(todo);
    }

    public TodoEntity updateTodo(Integer id, TodoEntity todo) {
        return todoRepository.findById(id).map(existingTodo -> {
            existingTodo.setTitle(todo.getTitle());
            existingTodo.setIsDone(todo.getIsDone());
            return todoRepository.save(existingTodo);
        }).orElseGet(() -> {
            todo.setId(id);
            return todoRepository.save(todo);
        });
    }

    public void deleteTodo(Integer id) {
        todoRepository.deleteById(id);
    }

    public Optional<TodoEntity> findTodoById(Integer id) {
        return todoRepository.findById(id);
    }
}


