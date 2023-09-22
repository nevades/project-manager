/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 *
 * @author Neva
 */
@Controller
public class PageController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/dashboard")
    public String dashboard() {
        return "dashboard";
    }

    @GetMapping("/dashboard_1")
    public String dashboard_1() {
        return "dashboard_1";
    }

    @GetMapping("/setup")
    public String setup() {
        return "setup";
    }

    @GetMapping("/management")
    public String management() {
        return "management";
    }

    @GetMapping("/advancedUsers")
    public String advancedUsers() {
        return "users";
    }

    @GetMapping("/advancedTasks")
    public String advancedTasks() {
        return "tasks";
    }

}
