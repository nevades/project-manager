package io.github.nevades.tasklane.board;

import io.github.nevades.tasklane.board.BoardMember.MemberRole;
import io.github.nevades.tasklane.card.CardDtos.CardSummary;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.util.List;

public final class BoardDtos {

    /** Background keys are resolved to gradients by the front end. */
    static final String BACKGROUND_PATTERN = "^[a-z0-9-]{1,40}$";
    static final String LABEL_COLOR_PATTERN = "^(green|yellow|orange|red|purple|blue|sky|lime|pink|gray)$";

    private BoardDtos() {
    }

    public record CreateBoardRequest(
            @NotBlank @Size(max = 120) String name,
            @Size(max = 2000) String description,
            @Pattern(regexp = BACKGROUND_PATTERN) String background) {
    }

    public record UpdateBoardRequest(
            @NotBlank @Size(max = 120) String name,
            @Size(max = 2000) String description,
            @NotNull @Pattern(regexp = BACKGROUND_PATTERN) String background) {
    }

    public record StarRequest(boolean starred) {
    }

    public record AddMemberRequest(@NotBlank @Email String email) {
    }

    public record LabelRequest(
            @NotBlank @Size(max = 60) String name,
            @NotNull @Pattern(regexp = LABEL_COLOR_PATTERN) String color) {
    }

    public record ListRequest(@NotBlank @Size(max = 120) String name) {
    }

    public record MoveListRequest(@NotNull @Min(0) Integer position) {
    }

    public record BoardSummary(Long id, String name, String description, String background, boolean starred,
            MemberRole role, Instant updatedAt) {

        static BoardSummary from(BoardMember membership) {
            Board board = membership.getBoard();
            return new BoardSummary(board.getId(), board.getName(), board.getDescription(), board.getBackground(),
                    membership.isStarred(), membership.getRole(), board.getUpdatedAt());
        }
    }

    public record BoardDetail(Long id, String name, String description, String background, boolean starred,
            MemberRole role, List<MemberResponse> members, List<LabelResponse> labels, List<ListResponse> lists) {
    }

    public record MemberResponse(Long id, String displayName, String email, MemberRole role) {

        static MemberResponse from(BoardMember member) {
            return new MemberResponse(member.getUser().getId(), member.getUser().getDisplayName(),
                    member.getUser().getEmail(), member.getRole());
        }
    }

    public record LabelResponse(Long id, String name, String color) {

        static LabelResponse from(Label label) {
            return new LabelResponse(label.getId(), label.getName(), label.getColor());
        }
    }

    public record ListResponse(Long id, String name, int position, List<CardSummary> cards) {

        static ListResponse from(BoardList list, List<CardSummary> cards) {
            return new ListResponse(list.getId(), list.getName(), list.getPosition(), cards);
        }
    }
}
