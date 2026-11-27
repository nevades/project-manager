package io.github.nevades.tasklane.user;

import jakarta.validation.constraints.NotNull;
import java.time.Instant;

public final class UserDtos {

    private UserDtos() {
    }

    /** Full view of a user, returned to the user themselves and to admins. */
    public record UserResponse(Long id, String email, String displayName, Role role, boolean active,
            Instant createdAt) {

        public static UserResponse from(User user) {
            return new UserResponse(user.getId(), user.getEmail(), user.getDisplayName(), user.getRole(),
                    user.isActive(), user.getCreatedAt());
        }
    }

    /** Minimal view of a user, safe to embed in board and card payloads. */
    public record UserSummary(Long id, String displayName, String email) {

        public static UserSummary from(User user) {
            return user == null ? null : new UserSummary(user.getId(), user.getDisplayName(), user.getEmail());
        }
    }

    public record AdminUpdateUserRequest(@NotNull Role role, boolean active) {
    }
}
