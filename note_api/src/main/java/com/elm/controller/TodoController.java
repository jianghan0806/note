package com.elm.controller;

import com.elm.entity.TodoEntity;
import com.elm.service.TodoService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/todos")
public class TodoController {

    private final TodoService todoService;

    @Autowired
    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    // 获取所有Todo项
    @GetMapping
    public ResponseEntity<List<TodoEntity>> getAllTodos() {
        return ResponseEntity.ok(todoService.findAllTodos());
    }

    // 根据ID获取单个Todo项
    @GetMapping("/{id}")
    public ResponseEntity<TodoEntity> getTodoById(@PathVariable Integer id) {
        return todoService.findTodoById(id)
                .map(todo -> ResponseEntity.ok(todo))
                .orElse(ResponseEntity.notFound().build());
    }

    // 创建新的Todo项
    @PostMapping
    public ResponseEntity<TodoEntity> createTodo(@RequestBody TodoEntity todo) {
        return ResponseEntity.ok(todoService.addTodo(todo));
    }

    // 更新现有的Todo项
    @PutMapping("/{id}")
    public ResponseEntity<TodoEntity> updateTodo(@PathVariable Integer id,
                                                 @RequestBody TodoEntity todo) {
        TodoEntity updatedTodo = todoService.updateTodo(id, todo);
        if (updatedTodo == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updatedTodo);
    }

    // 删除Todo项
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTodo(@PathVariable Integer id) {
        todoService.deleteTodo(id);
        return ResponseEntity.ok().build();
    }
}
