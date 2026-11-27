package io.github.nevades.tasklane.board;

import io.github.nevades.tasklane.board.BoardDtos.AddMemberRequest;
import io.github.nevades.tasklane.board.BoardDtos.BoardDetail;
import io.github.nevades.tasklane.board.BoardDtos.BoardSummary;
import io.github.nevades.tasklane.board.BoardDtos.CreateBoardRequest;
import io.github.nevades.tasklane.board.BoardDtos.LabelRequest;
import io.github.nevades.tasklane.board.BoardDtos.LabelResponse;
import io.github.nevades.tasklane.board.BoardDtos.ListResponse;
import io.github.nevades.tasklane.board.BoardDtos.MemberResponse;
import io.github.nevades.tasklane.board.BoardDtos.UpdateBoardRequest;
import io.github.nevades.tasklane.board.BoardMember.MemberRole;
import io.github.nevades.tasklane.card.CardDtos.CardSummary;
import io.github.nevades.tasklane.card.CardMapper;
import io.github.nevades.tasklane.card.CardRepository;
import io.github.nevades.tasklane.common.ApiErrors.BadRequestException;
import io.github.nevades.tasklane.common.ApiErrors.ConflictException;
import io.github.nevades.tasklane.common.ApiErrors.ForbiddenException;
import io.github.nevades.tasklane.common.ApiErrors.NotFoundException;
import io.github.nevades.tasklane.user.User;
import io.github.nevades.tasklane.user.UserRepository;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class BoardService {

    static final String DEFAULT_BACKGROUND = "ocean";
    static final List<String> DEFAULT_LISTS = List.of("To do", "In progress", "Done");

    private final BoardRepository boards;
    private final BoardMemberRepository members;
    private final BoardListRepository lists;
    private final LabelRepository labels;
    private final CardRepository cards;
    private final UserRepository users;
    private final BoardAccess access;

    public BoardService(BoardRepository boards, BoardMemberRepository members, BoardListRepository lists,
            LabelRepository labels, CardRepository cards, UserRepository users, BoardAccess access) {
        this.boards = boards;
        this.members = members;
        this.lists = lists;
        this.labels = labels;
        this.cards = cards;
        this.users = users;
        this.access = access;
    }

    // ---- Boards ---------------------------------------------------------------------------------------------

    @Transactional(readOnly = true)
    public List<BoardSummary> listBoards(Long userId) {
        return members.findAllForUser(userId).stream().map(BoardSummary::from).toList();
    }

    public BoardSummary createBoard(CreateBoardRequest request, Long userId) {
        User owner = users.getReferenceById(userId);
        String background = request.background() == null ? DEFAULT_BACKGROUND : request.background();
        Board board = boards.save(new Board(request.name().trim(), blankToNull(request.description()), background,
                owner));
        BoardMember membership = members.save(new BoardMember(board, owner, MemberRole.OWNER));
        for (int i = 0; i < DEFAULT_LISTS.size(); i++) {
            lists.save(new BoardList(board, DEFAULT_LISTS.get(i), i));
        }
        return BoardSummary.from(membership);
    }

    @Transactional(readOnly = true)
    public BoardDetail getBoard(Long boardId, Long userId) {
        BoardMember me = access.requireMember(boardId, userId);
        Board board = me.getBoard();

        Map<Long, List<CardSummary>> cardsByList = CardMapper.summariesForBoard(cards, boardId).stream()
                .collect(Collectors.groupingBy(CardSummary::listId));
        List<ListResponse> listResponses = lists.findByBoardIdOrderByPosition(boardId).stream()
                .map(list -> ListResponse.from(list, cardsByList.getOrDefault(list.getId(), List.of())))
                .toList();
        List<MemberResponse> memberResponses = members.findAllForBoard(boardId).stream()
                .map(MemberResponse::from).toList();
        List<LabelResponse> labelResponses = labels.findByBoardIdOrderById(boardId).stream()
                .map(LabelResponse::from).toList();

        return new BoardDetail(board.getId(), board.getName(), board.getDescription(), board.getBackground(),
                me.isStarred(), me.getRole(), memberResponses, labelResponses, listResponses);
    }

    public BoardSummary updateBoard(Long boardId, UpdateBoardRequest request, Long userId) {
        BoardMember me = access.requireOwner(boardId, userId);
        Board board = me.getBoard();
        board.setName(request.name().trim());
        board.setDescription(blankToNull(request.description()));
        board.setBackground(request.background());
        board.touch();
        return BoardSummary.from(me);
    }

    public void setStarred(Long boardId, boolean starred, Long userId) {
        access.requireMember(boardId, userId).setStarred(starred);
    }

    public void deleteBoard(Long boardId, Long userId) {
        access.requireOwner(boardId, userId);
        boards.deleteById(boardId);
    }

    // ---- Members --------------------------------------------------------------------------------------------

    public MemberResponse addMember(Long boardId, AddMemberRequest request, Long userId) {
        BoardMember me = access.requireOwner(boardId, userId);
        User user = users.findByEmailIgnoreCase(request.email().trim())
                .filter(User::isActive)
                .orElseThrow(() -> new NotFoundException("No active user with that email address."));
        if (members.findByBoardIdAndUserId(boardId, user.getId()).isPresent()) {
            throw new ConflictException("That user is already a member of this board.");
        }
        return MemberResponse.from(members.save(new BoardMember(me.getBoard(), user, MemberRole.MEMBER)));
    }

    /** Owners can remove anyone except themselves; members can remove themselves (leave the board). */
    public void removeMember(Long boardId, Long memberUserId, Long userId) {
        BoardMember me = access.requireMember(boardId, userId);
        if (!me.isOwner() && !memberUserId.equals(userId)) {
            throw new ForbiddenException("Only the board owner can remove other members.");
        }
        BoardMember target = members.findByBoardIdAndUserId(boardId, memberUserId)
                .orElseThrow(() -> new NotFoundException("Member not found."));
        if (target.isOwner()) {
            throw new BadRequestException("The board owner cannot be removed. Delete the board instead.");
        }
        cards.unassignUserOnBoard(memberUserId, boardId);
        members.delete(target);
    }

    // ---- Labels ---------------------------------------------------------------------------------------------

    public LabelResponse createLabel(Long boardId, LabelRequest request, Long userId) {
        Board board = access.requireMember(boardId, userId).getBoard();
        return LabelResponse.from(labels.save(new Label(board, request.name().trim(), request.color())));
    }

    public LabelResponse updateLabel(Long labelId, LabelRequest request, Long userId) {
        Label label = labels.findById(labelId).orElseThrow(() -> new NotFoundException("Label not found."));
        access.requireMember(label.getBoard().getId(), userId);
        label.setName(request.name().trim());
        label.setColor(request.color());
        return LabelResponse.from(label);
    }

    public void deleteLabel(Long labelId, Long userId) {
        Label label = labels.findById(labelId).orElseThrow(() -> new NotFoundException("Label not found."));
        access.requireMember(label.getBoard().getId(), userId);
        labels.delete(label);
    }

    // ---- Lists ----------------------------------------------------------------------------------------------

    public ListResponse createList(Long boardId, String name, Long userId) {
        Board board = access.requireMember(boardId, userId).getBoard();
        BoardList list = lists.save(new BoardList(board, name.trim(), lists.countByBoardId(boardId)));
        board.touch();
        return ListResponse.from(list, List.of());
    }

    public ListResponse renameList(Long listId, String name, Long userId) {
        BoardList list = requireList(listId, userId);
        list.setName(name.trim());
        return ListResponse.from(list, List.of());
    }

    public void moveList(Long listId, int position, Long userId) {
        BoardList list = requireList(listId, userId);
        List<BoardList> siblings = lists.findByBoardIdOrderByPosition(list.getBoard().getId());
        Positioned.moveTo(siblings, list, position);
        list.getBoard().touch();
    }

    public void deleteList(Long listId, Long userId) {
        BoardList list = requireList(listId, userId);
        Long boardId = list.getBoard().getId();
        lists.delete(list);
        lists.flush();
        Positioned.renumber(lists.findByBoardIdOrderByPosition(boardId));
    }

    private BoardList requireList(Long listId, Long userId) {
        BoardList list = lists.findById(listId).orElseThrow(() -> new NotFoundException("List not found."));
        access.requireMember(list.getBoard().getId(), userId);
        return list;
    }

    private static String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
