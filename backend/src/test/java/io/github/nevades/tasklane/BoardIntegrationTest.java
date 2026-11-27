package io.github.nevades.tasklane;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.ResultActions;

class BoardIntegrationTest extends IntegrationTestSupport {

    private MockHttpSession owner;
    private long boardId;
    private long todoId;
    private long doingId;

    @BeforeEach
    void createBoard() throws Exception {
        owner = register("owner@example.com", "Owner");
        ResultActions created = send(post("/api/boards"), owner, "{\"name\":\"Launch\"}")
                .andExpect(status().isCreated());
        boardId = readId(created, "$.id");

        ResultActions board = getJson("/api/boards/" + boardId, owner)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.role").value("OWNER"))
                .andExpect(jsonPath("$.lists.length()").value(3));
        todoId = readId(board, "$.lists[0].id");
        doingId = readId(board, "$.lists[1].id");
    }

    @Test
    void cardsCanBeReorderedAndMovedBetweenLists() throws Exception {
        long a = createCard(todoId, "A");
        long b = createCard(todoId, "B");
        long c = createCard(todoId, "C");

        // Reorder within the same list: C to the top.
        send(post("/api/cards/" + c + "/move"), owner, "{\"listId\":" + todoId + ",\"position\":0}")
                .andExpect(status().isNoContent());
        assertThat(cardTitles(0)).containsExactly("C", "A", "B");

        // Move A into the second list.
        send(post("/api/cards/" + a + "/move"), owner, "{\"listId\":" + doingId + ",\"position\":0}")
                .andExpect(status().isNoContent());
        assertThat(cardTitles(0)).containsExactly("C", "B");
        assertThat(cardTitles(1)).containsExactly("A");

        ResultActions board = getJson("/api/boards/" + boardId, owner);
        List<Integer> positions = read(board, "$.lists[0].cards[*].position");
        assertThat(positions).containsExactly(0, 1);

        send(delete("/api/cards/" + b), owner, null).andExpect(status().isNoContent());
        assertThat(cardTitles(0)).containsExactly("C");
    }

    @Test
    void listsCanBeReordered() throws Exception {
        send(post("/api/lists/" + todoId + "/move"), owner, "{\"position\":2}").andExpect(status().isNoContent());

        getJson("/api/boards/" + boardId, owner)
                .andExpect(jsonPath("$.lists[0].name").value("In progress"))
                .andExpect(jsonPath("$.lists[2].name").value("To do"));
    }

    @Test
    void cardDetailsCanBeUpdatedWithLabelsAssigneeChecklistAndComments() throws Exception {
        MockHttpSession member = register("member@example.com", "Member");
        long memberId = readId(send(post("/api/boards/" + boardId + "/members"), owner,
                "{\"email\":\"member@example.com\"}").andExpect(status().isCreated()), "$.id");
        long labelId = readId(send(post("/api/boards/" + boardId + "/labels"), owner,
                "{\"name\":\"Bug\",\"color\":\"red\"}").andExpect(status().isCreated()), "$.id");
        long cardId = createCard(todoId, "Fix login");

        send(put("/api/cards/" + cardId), member, """
                {"title":"Fix login bug","description":"Steps...","priority":"HIGH","dueDate":"2030-01-31",
                 "assigneeId":%d,"completed":false,"labelIds":[%d]}
                """.formatted(memberId, labelId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.assignee.displayName").value("Member"))
                .andExpect(jsonPath("$.labelIds[0]").value(labelId));

        long itemId = readId(send(post("/api/cards/" + cardId + "/checklist"), member,
                "{\"content\":\"Reproduce\"}").andExpect(status().isCreated()), "$.id");
        send(put("/api/checklist-items/" + itemId), member, "{\"content\":\"Reproduce\",\"done\":true}")
                .andExpect(jsonPath("$.done").value(true));
        send(post("/api/cards/" + cardId + "/comments"), owner, "{\"body\":\"On it?\"}")
                .andExpect(status().isCreated());

        getJson("/api/boards/" + boardId, member)
                .andExpect(jsonPath("$.lists[0].cards[0].checklistDone").value(1))
                .andExpect(jsonPath("$.lists[0].cards[0].checklistTotal").value(1))
                .andExpect(jsonPath("$.lists[0].cards[0].commentCount").value(1))
                .andExpect(jsonPath("$.lists[0].cards[0].hasDescription").value(true));

        // Removing the member unassigns their cards.
        send(delete("/api/boards/" + boardId + "/members/" + memberId), owner, null)
                .andExpect(status().isNoContent());
        getJson("/api/cards/" + cardId, owner).andExpect(jsonPath("$.assignee").isEmpty());
    }

    @Test
    void nonMembersCannotSeeOrChangeTheBoard() throws Exception {
        MockHttpSession outsider = register("outsider@example.com", "Outsider");
        long cardId = createCard(todoId, "Secret");

        getJson("/api/boards/" + boardId, outsider).andExpect(status().isNotFound());
        getJson("/api/cards/" + cardId, outsider).andExpect(status().isNotFound());
        send(post("/api/lists/" + todoId + "/cards"), outsider, "{\"title\":\"Sneaky\"}")
                .andExpect(status().isNotFound());
        getJson("/api/boards", outsider).andExpect(jsonPath("$.length()").value(0));
    }

    @Test
    void labelsAndAssigneesMustBelongToTheBoard() throws Exception {
        MockHttpSession other = register("other@example.com", "Other");
        long otherBoard = readId(send(post("/api/boards"), other, "{\"name\":\"Other\"}"), "$.id");
        long foreignLabel = readId(send(post("/api/boards/" + otherBoard + "/labels"), other,
                "{\"name\":\"X\",\"color\":\"blue\"}"), "$.id");
        long cardId = createCard(todoId, "Card");

        send(put("/api/cards/" + cardId), owner, """
                {"title":"Card","priority":"NONE","completed":false,"labelIds":[%d]}
                """.formatted(foreignLabel)).andExpect(status().isBadRequest());
    }

    @Test
    void onlyOwnersCanDeleteBoards() throws Exception {
        MockHttpSession member = register("member@example.com", "Member");
        send(post("/api/boards/" + boardId + "/members"), owner, "{\"email\":\"member@example.com\"}");

        send(delete("/api/boards/" + boardId), member, null).andExpect(status().isForbidden());
        send(delete("/api/boards/" + boardId), owner, null).andExpect(status().isNoContent());
        getJson("/api/boards/" + boardId, owner).andExpect(status().isNotFound());
    }

    private long createCard(long listId, String title) throws Exception {
        return readId(send(post("/api/lists/" + listId + "/cards"), owner, "{\"title\":\"" + title + "\"}")
                .andExpect(status().isCreated()), "$.id");
    }

    private List<String> cardTitles(int listIndex) throws Exception {
        return read(getJson("/api/boards/" + boardId, owner), "$.lists[" + listIndex + "].cards[*].title");
    }
}
