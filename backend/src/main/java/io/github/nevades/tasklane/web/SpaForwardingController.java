package io.github.nevades.tasklane.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Serves the single-page app's index.html for client-side routes so deep links and page refreshes work.
 */
@Controller
public class SpaForwardingController {

    @GetMapping({"/login", "/register", "/boards/**", "/admin", "/admin/**"})
    public String forwardToIndex() {
        return "forward:/index.html";
    }
}
