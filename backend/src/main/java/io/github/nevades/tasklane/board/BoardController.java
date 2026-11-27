package io.github.nevades.tasklane.board;

import io.github.nevades.tasklane.board.BoardDtos.AddMemberRequest;
import io.github.nevades.tasklane.board.BoardDtos.BoardDetail;
import io.github.nevades.tasklane.board.BoardDtos.BoardSummary;
import io.github.nevades.tasklane.board.BoardDtos.CreateBoardRequest;
import io.github.nevades.tasklane.board.BoardDtos.LabelRequest;
import io.github.nevades.tasklane.board.BoardDtos.LabelResponse;
import io.github.nevades.tasklane.board.BoardDtos.ListRequest;
import io.github.nevades.tasklane.board.BoardDtos.ListResponse;
import io.github.nevades.tasklane.board.BoardDtos.MemberResponse;
import io.github.nevades.tasklane.board.BoardDtos.MoveListRequest;
import io.github.nevades.tasklane.board.BoardDtos.StarRequest;
import io.github.nevades.tasklane.board.BoardDtos.UpdateBoardRequest;
import io.github.nevades.tasklane.security.AppUserDetails;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class BoardController {

    private final BoardService service;

    public BoardController(BoardService service) {
        this.service = service;
    }

    // ---- Boards ---------------------------------------------------------------------------------------------

    @GetMapping("/boards")
    public List<BoardSummary> listBoards(@AuthenticationPrincipal AppUserDetails user) {
        return service.listBoards(user.getId());
    }

    @PostMapping("/boards")
    @ResponseStatus(HttpStatus.CREATED)
    public BoardSummary createBoard(@Valid @RequestBody CreateBoardRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.createBoard(request, user.getId());
    }

    @GetMapping("/boards/{boardId}")
    public BoardDetail getBoard(@PathVariable Long boardId, @AuthenticationPrincipal AppUserDetails user) {
        return service.getBoard(boardId, user.getId());
    }

    @PutMapping("/boards/{boardId}")
    public BoardSummary updateBoard(@PathVariable Long boardId, @Valid @RequestBody UpdateBoardRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.updateBoard(boardId, request, user.getId());
    }

    @PutMapping("/boards/{boardId}/star")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void star(@PathVariable Long boardId, @RequestBody StarRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        service.setStarred(boardId, request.starred(), user.getId());
    }

    @DeleteMapping("/boards/{boardId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteBoard(@PathVariable Long boardId, @AuthenticationPrincipal AppUserDetails user) {
        service.deleteBoard(boardId, user.getId());
    }

    // ---- Members --------------------------------------------------------------------------------------------

    @PostMapping("/boards/{boardId}/members")
    @ResponseStatus(HttpStatus.CREATED)
    public MemberResponse addMember(@PathVariable Long boardId, @Valid @RequestBody AddMemberRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.addMember(boardId, request, user.getId());
    }

    @DeleteMapping("/boards/{boardId}/members/{memberId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void removeMember(@PathVariable Long boardId, @PathVariable Long memberId,
            @AuthenticationPrincipal AppUserDetails user) {
        service.removeMember(boardId, memberId, user.getId());
    }

    // ---- Labels ---------------------------------------------------------------------------------------------

    @PostMapping("/boards/{boardId}/labels")
    @ResponseStatus(HttpStatus.CREATED)
    public LabelResponse createLabel(@PathVariable Long boardId, @Valid @RequestBody LabelRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.createLabel(boardId, request, user.getId());
    }

    @PutMapping("/labels/{labelId}")
    public LabelResponse updateLabel(@PathVariable Long labelId, @Valid @RequestBody LabelRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.updateLabel(labelId, request, user.getId());
    }

    @DeleteMapping("/labels/{labelId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteLabel(@PathVariable Long labelId, @AuthenticationPrincipal AppUserDetails user) {
        service.deleteLabel(labelId, user.getId());
    }

    // ---- Lists ----------------------------------------------------------------------------------------------

    @PostMapping("/boards/{boardId}/lists")
    @ResponseStatus(HttpStatus.CREATED)
    public ListResponse createList(@PathVariable Long boardId, @Valid @RequestBody ListRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.createList(boardId, request.name(), user.getId());
    }

    @PutMapping("/lists/{listId}")
    public ListResponse renameList(@PathVariable Long listId, @Valid @RequestBody ListRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.renameList(listId, request.name(), user.getId());
    }

    @PostMapping("/lists/{listId}/move")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void moveList(@PathVariable Long listId, @Valid @RequestBody MoveListRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        service.moveList(listId, request.position(), user.getId());
    }

    @DeleteMapping("/lists/{listId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteList(@PathVariable Long listId, @AuthenticationPrincipal AppUserDetails user) {
        service.deleteList(listId, user.getId());
    }
}
