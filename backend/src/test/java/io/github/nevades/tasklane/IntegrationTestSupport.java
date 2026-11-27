package io.github.nevades.tasklane;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.jayway.jsonpath.JsonPath;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public abstract class IntegrationTestSupport {

    @Autowired
    protected MockMvc mvc;

    @Autowired
    private JdbcTemplate jdbc;

    @BeforeEach
    void cleanDatabase() {
        jdbc.update("delete from boards");
        jdbc.update("delete from users");
    }

    /** Registers a user and returns the authenticated session. */
    protected MockHttpSession register(String email, String name) throws Exception {
        MockHttpSession session = new MockHttpSession();
        mvc.perform(post("/api/auth/register").session(session).with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","displayName":"%s","password":"password123"}
                                """.formatted(email, name)))
                .andExpect(status().isCreated());
        return session;
    }

    protected ResultActions send(MockHttpServletRequestBuilder request, MockHttpSession session, String json)
            throws Exception {
        request.session(session).with(csrf());
        if (json != null) {
            request.contentType(MediaType.APPLICATION_JSON).content(json);
        }
        return mvc.perform(request);
    }

    protected ResultActions getJson(String url, MockHttpSession session) throws Exception {
        return mvc.perform(get(url).session(session));
    }

    protected static <T> T read(ResultActions result, String path) throws Exception {
        return JsonPath.read(result.andReturn().getResponse().getContentAsString(), path);
    }

    protected static long readId(ResultActions result, String path) throws Exception {
        return ((Number) read(result, path)).longValue();
    }
}
