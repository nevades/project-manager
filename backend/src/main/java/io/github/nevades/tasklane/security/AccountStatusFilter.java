package io.github.nevades.tasklane.security;

import io.github.nevades.tasklane.user.User;
import io.github.nevades.tasklane.user.UserRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Re-validates the signed-in account on every API request so that admin changes take effect immediately:
 * deactivated or deleted accounts are signed out, and role changes refresh the session's authorities.
 */
public class AccountStatusFilter extends OncePerRequestFilter {

    private final UserRepository users;
    private final SecurityContextRepository contextRepository;

    public AccountStatusFilter(UserRepository users, SecurityContextRepository contextRepository) {
        this.users = users;
        this.contextRepository = contextRepository;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !request.getRequestURI().startsWith("/api/");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof AppUserDetails principal) {
            Optional<User> user = users.findById(principal.getId());
            if (user.isEmpty() || !user.get().isActive()) {
                SecurityContextHolder.clearContext();
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            if (!principal.getAuthorities().equals(new AppUserDetails(user.get()).getAuthorities())) {
                AppUserDetails refreshed = new AppUserDetails(user.get());
                SecurityContext context = SecurityContextHolder.createEmptyContext();
                context.setAuthentication(UsernamePasswordAuthenticationToken.authenticated(
                        refreshed, null, refreshed.getAuthorities()));
                SecurityContextHolder.setContext(context);
                contextRepository.saveContext(context, request, response);
            }
        }
        chain.doFilter(request, response);
    }
}
