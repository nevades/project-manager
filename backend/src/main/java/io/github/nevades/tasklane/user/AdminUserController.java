package io.github.nevades.tasklane.user;

import io.github.nevades.tasklane.common.ApiErrors.BadRequestException;
import io.github.nevades.tasklane.common.ApiErrors.NotFoundException;
import io.github.nevades.tasklane.security.AppUserDetails;
import io.github.nevades.tasklane.user.UserDtos.AdminUpdateUserRequest;
import io.github.nevades.tasklane.user.UserDtos.UserResponse;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * User administration. Restricted to {@link Role#ADMIN} by the security configuration.
 */
@RestController
@RequestMapping("/api/admin/users")
public class AdminUserController {

    private final UserRepository users;

    public AdminUserController(UserRepository users) {
        this.users = users;
    }

    @GetMapping
    public List<UserResponse> list() {
        return users.findAllByOrderByCreatedAtAsc().stream().map(UserResponse::from).toList();
    }

    @PutMapping("/{id}")
    @Transactional
    public UserResponse update(@PathVariable Long id, @Valid @RequestBody AdminUpdateUserRequest request,
            @AuthenticationPrincipal AppUserDetails principal) {
        User user = users.findById(id).orElseThrow(() -> new NotFoundException("User not found."));
        boolean self = user.getId().equals(principal.getId());
        if (self && (request.role() != Role.ADMIN || !request.active())) {
            throw new BadRequestException("You cannot remove your own admin access or deactivate yourself.");
        }
        user.setRole(request.role());
        user.setActive(request.active());
        return UserResponse.from(user);
    }
}
