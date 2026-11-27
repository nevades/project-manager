package io.github.nevades.tasklane.security;

import io.github.nevades.tasklane.common.ApiErrors.ConflictException;
import io.github.nevades.tasklane.common.ApiErrors.ForbiddenException;
import io.github.nevades.tasklane.user.Role;
import io.github.nevades.tasklane.user.User;
import io.github.nevades.tasklane.user.UserDtos.UserResponse;
import io.github.nevades.tasklane.user.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.Locale;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final SecurityContextRepository contextRepository;
    private final UserRepository users;
    private final PasswordEncoder passwordEncoder;
    private final boolean registrationEnabled;
    private final boolean demoEnabled;

    public AuthController(AuthenticationManager authenticationManager, SecurityContextRepository contextRepository,
            UserRepository users, PasswordEncoder passwordEncoder,
            @Value("${app.registration.enabled:true}") boolean registrationEnabled,
            @Value("${app.demo-data.enabled:false}") boolean demoEnabled) {
        this.authenticationManager = authenticationManager;
        this.contextRepository = contextRepository;
        this.users = users;
        this.passwordEncoder = passwordEncoder;
        this.registrationEnabled = registrationEnabled;
        this.demoEnabled = demoEnabled;
    }

    /** Issues the CSRF cookie. The SPA calls this once on start-up before any mutating request. */
    @GetMapping("/csrf")
    public Map<String, String> csrf(CsrfToken token) {
        return Map.of("headerName", token.getHeaderName(), "token", token.getToken());
    }

    /** Public settings the login screen needs before the user is authenticated. */
    @GetMapping("/config")
    public Map<String, Boolean> config() {
        return Map.of("registrationEnabled", registrationEnabled, "demoEnabled", demoEnabled);
    }

    @GetMapping("/me")
    public UserResponse me(@AuthenticationPrincipal AppUserDetails principal) {
        return users.findById(principal.getId())
                .map(UserResponse::from)
                .orElseThrow(() -> new ForbiddenException("Account no longer exists."));
    }

    @PostMapping("/login")
    public UserResponse login(@Valid @RequestBody LoginRequest request, HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {
        Authentication authentication = authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken.unauthenticated(request.email().trim(), request.password()));
        establishSession(authentication, httpRequest, httpResponse);
        AppUserDetails principal = (AppUserDetails) authentication.getPrincipal();
        return users.findById(principal.getId()).map(UserResponse::from).orElseThrow();
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    @Transactional
    public UserResponse register(@Valid @RequestBody RegisterRequest request, HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {
        if (!registrationEnabled) {
            throw new ForbiddenException("Self-registration is disabled. Ask an administrator for an account.");
        }
        String email = request.email().trim().toLowerCase(Locale.ROOT);
        if (users.existsByEmailIgnoreCase(email)) {
            throw new ConflictException("An account with this email already exists.");
        }
        // The very first account becomes the administrator.
        Role role = users.count() == 0 ? Role.ADMIN : Role.USER;
        User user = users.save(new User(email, request.displayName().trim(),
                passwordEncoder.encode(request.password()), role));

        AppUserDetails principal = new AppUserDetails(user);
        Authentication authentication = UsernamePasswordAuthenticationToken.authenticated(
                principal, null, principal.getAuthorities());
        establishSession(authentication, httpRequest, httpResponse);
        return UserResponse.from(user);
    }

    private void establishSession(Authentication authentication, HttpServletRequest request,
            HttpServletResponse response) {
        // Protect against session fixation by issuing a fresh session id on login.
        if (request.getSession(false) != null) {
            request.changeSessionId();
        }
        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(authentication);
        SecurityContextHolder.setContext(context);
        contextRepository.saveContext(context, request, response);
    }

    public record LoginRequest(@NotBlank @Email String email, @NotBlank String password) {
    }

    public record RegisterRequest(
            @NotBlank @Email @Size(max = 255) String email,
            @NotBlank @Size(max = 100) String displayName,
            @NotBlank @Size(min = 8, max = 128) String password) {
    }
}
