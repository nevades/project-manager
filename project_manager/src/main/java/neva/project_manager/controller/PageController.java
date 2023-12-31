package neva.project_manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

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

    @GetMapping("/admin")
    public String admin() {
        return "admin";
    }

}
