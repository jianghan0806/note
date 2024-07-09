package com.elm.controller;

import com.elm.entity.UserEntity;
import com.elm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    // 获取所有User
    @GetMapping
    public ResponseEntity<List<UserEntity>> getAllUsers() {
        List<UserEntity> users = userService.findAllUsers();
        return ResponseEntity.ok(users);
    }

    // 根据ID获取单个User
    @GetMapping("/{id}")
    public ResponseEntity<UserEntity> getUserById(@PathVariable Integer id) {
        Optional<UserEntity> user = userService.findUserById(id);
        return user.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    // 创建新的User
    @PostMapping
    public ResponseEntity<UserEntity> createUser(@RequestBody UserEntity user) {
        UserEntity createdUser = userService.addUser(user);
        return ResponseEntity.ok(createdUser);
    }

    // 更新现有的User
    @PutMapping("/{id}")
    public ResponseEntity<UserEntity> updateUser(@PathVariable Integer id, @RequestBody UserEntity user) {
        UserEntity updatedUser = userService.updateUser(id, user);
        return ResponseEntity.ok(updatedUser);
    }

    // 删除User
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Integer id) {
        userService.deleteUser(id);
        return ResponseEntity.ok().build();
    }

    // 根据用户名和密码查找User
    @GetMapping("/search")
    public ResponseEntity<Optional<UserEntity>> getUserByUsernameAndPassword(@RequestParam String username, @RequestParam String password) {
        Optional<UserEntity> user = userService.findUserByUsernameAndPassword(username, password);
        return ResponseEntity.ok(user);
    }

    // 根据用户名查找User
    @GetMapping("/search/username")
    public ResponseEntity<List<UserEntity>> getUserByUsername(@RequestParam String username) {
        List<UserEntity> users = userService.findUserByUsername(username);
        return ResponseEntity.ok(users);
    }
}
