/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.service;

import neva.project_manager.repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import neva.project_manager.model.User;

/**
 *
 * @author Neva
 */
@Service
public class LoginService {

    @Autowired
    UserRepo UserRepo;

    public User checkLogin(String username) {
        return UserRepo.findByUsername(username).orElse(null);
    }
}
