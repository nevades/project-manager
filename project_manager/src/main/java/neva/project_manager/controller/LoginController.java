package neva.project_manager.controller;

import jakarta.servlet.http.HttpSession;
import neva.project_manager.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import neva.project_manager.model.User;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
public class LoginController {

    @Autowired
    LoginService LoginService;

    @PostMapping("/login")
    public String checkLogin(@RequestParam String username, @RequestParam String password, HttpSession session) {

        User user = LoginService.checkLogin(username);

        if (user == null) {
            return "error";
        } else {

            session.setAttribute("uid", user.getId());
            session.setAttribute("username", username);

            return "ok";
        }

    }

    @GetMapping("/logout")
    public String Logout(HttpSession session) {

        session.removeAttribute("uid");
        session.removeAttribute("username");

        return "ok";
    }

}
