package io.github.nevades.tasklane.card;

import io.github.nevades.tasklane.board.Label;
import io.github.nevades.tasklane.user.UserDtos.UserSummary;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public final class CardDtos {

    private CardDtos() {
    }

    public record CreateCardRequest(@NotBlank @Size(max = 255) String title) {
    }

    /** Full replacement of a card's editable fields. */
    public record UpdateCardRequest(
            @NotBlank @Size(max = 255) String title,
            @Size(max = 10000) String description,
            @NotNull Priority priority,
            LocalDate dueDate,
            Long assigneeId,
            boolean completed,
            @NotNull List<Long> labelIds) {
    }

    public record MoveCardRequest(@NotNull Long listId, @NotNull @Min(0) Integer position) {
    }

    public record ChecklistItemRequest(@NotBlank @Size(max = 500) String content) {
    }

    public record UpdateChecklistItemRequest(@NotBlank @Size(max = 500) String content, boolean done) {
    }

    public record CommentRequest(@NotBlank @Size(max = 5000) String body) {
    }

    /** Compact card shown on the board, including badge counts. */
    public record CardSummary(Long id, Long listId, String title, int position, Priority priority,
            LocalDate dueDate, boolean completed, UserSummary assignee, List<Long> labelIds,
            boolean hasDescription, long checklistDone, long checklistTotal, long commentCount) {
    }

    public record CardDetail(Long id, Long listId, String listName, Long boardId, String title, String description,
            Priority priority, LocalDate dueDate, boolean completed, UserSummary assignee, List<Long> labelIds,
            UserSummary createdBy, Instant createdAt, Instant updatedAt, List<ChecklistItemResponse> checklist,
            List<CommentResponse> comments) {
    }

    public record ChecklistItemResponse(Long id, String content, boolean done, int position) {

        static ChecklistItemResponse from(ChecklistItem item) {
            return new ChecklistItemResponse(item.getId(), item.getContent(), item.isDone(), item.getPosition());
        }
    }

    public record CommentResponse(Long id, String body, UserSummary author, Instant createdAt) {

        static CommentResponse from(Comment comment) {
            return new CommentResponse(comment.getId(), comment.getBody(), UserSummary.from(comment.getAuthor()),
                    comment.getCreatedAt());
        }
    }

    static List<Long> labelIds(Card card) {
        return card.getLabels().stream().map(Label::getId).sorted().toList();
    }
}
