package io.github.nevades.tasklane;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;

class AuthIntegrationTest extends IntegrationTestSupport {

    @Test
    void firstRegisteredUserBecomesAdminAndLaterUsersDoNot() throws Exception {
        MockHttpSession first = register("first@example.com", "First");
        getJson("/api/auth/me", first)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("first@example.com"))
                .andExpect(jsonPath("$.role").value("ADMIN"));

        MockHttpSession second = register("second@example.com", "Second");
        getJson("/api/auth/me", second).andExpect(jsonPath("$.role").value("USER"));
    }

    @Test
    void loginChecksThePassword() throws Exception {
        register("user@example.com", "User");

        mvc.perform(post("/api/auth/login").with(csrf()).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"user@example.com\",\"password\":\"wrong-password\"}"))
                .andExpect(status().isUnauthorized());

        mvc.perform(post("/api/auth/login").with(csrf()).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"USER@example.com\",\"password\":\"password123\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.displayName").value("User"));
    }

    @Test
    void rejectsDuplicateEmailsAndWeakPasswords() throws Exception {
        register("dup@example.com", "Dup");

        mvc.perform(post("/api/auth/register").with(csrf()).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"dup@example.com\",\"displayName\":\"Again\",\"password\":\"password123\"}"))
                .andExpect(status().isConflict());

        mvc.perform(post("/api/auth/register").with(csrf()).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"new@example.com\",\"displayName\":\"New\",\"password\":\"short\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void apiRequiresAuthenticationAndCsrf() throws Exception {
        mvc.perform(get("/api/boards")).andExpect(status().isUnauthorized());

        MockHttpSession session = register("csrf@example.com", "Csrf");
        mvc.perform(post("/api/boards").session(session).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"No token\"}"))
                .andExpect(status().isForbidden());
    }

    @Test
    void adminChangesApplyToExistingSessionsImmediately() throws Exception {
        MockHttpSession admin = register("boss@example.com", "Boss");
        MockHttpSession user = register("worker@example.com", "Worker");
        long userId = readId(getJson("/api/auth/me", user), "$.id");

        // Promotion takes effect without signing in again.
        send(put("/api/admin/users/" + userId), admin, "{\"role\":\"ADMIN\",\"active\":true}")
                .andExpect(status().isOk());
        getJson("/api/admin/users", user).andExpect(status().isOk());

        // Deactivation signs the user out of their current session.
        send(put("/api/admin/users/" + userId), admin, "{\"role\":\"USER\",\"active\":false}")
                .andExpect(status().isOk());
        getJson("/api/boards", user).andExpect(status().isUnauthorized());
        mvc.perform(post("/api/auth/login").with(csrf()).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"worker@example.com\",\"password\":\"password123\"}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void adminsCannotDemoteThemselves() throws Exception {
        MockHttpSession admin = register("self@example.com", "Self");
        long adminId = readId(getJson("/api/auth/me", admin), "$.id");
        send(put("/api/admin/users/" + adminId), admin, "{\"role\":\"USER\",\"active\":true}")
                .andExpect(status().isBadRequest());
    }

    @Test
    void adminEndpointsAreRestrictedToAdmins() throws Exception {
        MockHttpSession admin = register("admin@example.com", "Admin");
        MockHttpSession user = register("member@example.com", "Member");

        getJson("/api/admin/users", user).andExpect(status().isForbidden());
        getJson("/api/admin/users", admin)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2));
    }
}
