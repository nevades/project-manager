/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.config;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.AuditorAware;
import org.springframework.stereotype.Component;

/**
 *
 * @author Neva
 */
@Component
public class HttpSessionAuditorAware implements AuditorAware<Integer> {

    private final HttpSession httpSession;

    @Autowired
    public HttpSessionAuditorAware(HttpSession httpSession) {
        this.httpSession = httpSession;
    }

    @Override
    public Optional<Integer> getCurrentAuditor() {
        Integer currentUser = (Integer) httpSession.getAttribute("uid");
        return Optional.ofNullable(currentUser);
    }
}
