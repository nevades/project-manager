package neva.project_manager.service;

import neva.project_manager.repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import neva.project_manager.model.User;

@Service
public class LoginService {

    @Autowired
    UserRepo UserRepo;

    public User checkLogin(String username) {
        return UserRepo.findByUsername(username).orElse(null);
    }
}
