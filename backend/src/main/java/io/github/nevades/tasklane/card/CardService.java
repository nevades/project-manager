package io.github.nevades.tasklane.card;

import io.github.nevades.tasklane.board.BoardAccess;
import io.github.nevades.tasklane.board.BoardList;
import io.github.nevades.tasklane.board.BoardListRepository;
import io.github.nevades.tasklane.board.BoardMemberRepository;
import io.github.nevades.tasklane.board.Label;
import io.github.nevades.tasklane.board.LabelRepository;
import io.github.nevades.tasklane.board.Positioned;
import io.github.nevades.tasklane.card.CardDtos.CardDetail;
import io.github.nevades.tasklane.card.CardDtos.CardSummary;
import io.github.nevades.tasklane.card.CardDtos.ChecklistItemResponse;
import io.github.nevades.tasklane.card.CardDtos.CommentResponse;
import io.github.nevades.tasklane.card.CardDtos.MoveCardRequest;
import io.github.nevades.tasklane.card.CardDtos.UpdateCardRequest;
import io.github.nevades.tasklane.card.CardDtos.UpdateChecklistItemRequest;
import io.github.nevades.tasklane.common.ApiErrors.BadRequestException;
import io.github.nevades.tasklane.common.ApiErrors.ForbiddenException;
import io.github.nevades.tasklane.common.ApiErrors.NotFoundException;
import io.github.nevades.tasklane.user.User;
import io.github.nevades.tasklane.user.UserDtos.UserSummary;
import io.github.nevades.tasklane.user.UserRepository;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class CardService {

    private final CardRepository cards;
    private final BoardListRepository lists;
    private final LabelRepository labels;
    private final ChecklistItemRepository checklistItems;
    private final CommentRepository comments;
    private final BoardMemberRepository members;
    private final UserRepository users;
    private final BoardAccess access;

    public CardService(CardRepository cards, BoardListRepository lists, LabelRepository labels,
            ChecklistItemRepository checklistItems, CommentRepository comments, BoardMemberRepository members,
            UserRepository users, BoardAccess access) {
        this.cards = cards;
        this.lists = lists;
        this.labels = labels;
        this.checklistItems = checklistItems;
        this.comments = comments;
        this.members = members;
        this.users = users;
        this.access = access;
    }

    // ---- Cards ----------------------------------------------------------------------------------------------

    public CardSummary createCard(Long listId, String title, Long userId) {
        BoardList list = lists.findById(listId).orElseThrow(() -> new NotFoundException("List not found."));
        access.requireMember(list.getBoard().getId(), userId);
        Card card = cards.save(new Card(list, title.trim(), cards.countByListId(listId),
                users.getReferenceById(userId)));
        list.getBoard().touch();
        return summary(card);
    }

    @Transactional(readOnly = true)
    public CardDetail getCard(Long cardId, Long userId) {
        return detail(requireCard(cardId, userId));
    }

    public CardDetail updateCard(Long cardId, UpdateCardRequest request, Long userId) {
        Card card = requireCard(cardId, userId);
        Long boardId = boardId(card);

        User assignee = null;
        if (request.assigneeId() != null) {
            assignee = members.findByBoardIdAndUserId(boardId, request.assigneeId())
                    .orElseThrow(() -> new BadRequestException("The assignee must be a member of this board."))
                    .getUser();
        }

        List<Label> newLabels = labels.findAllById(new HashSet<>(request.labelIds()));
        if (newLabels.size() != new HashSet<>(request.labelIds()).size()
                || newLabels.stream().anyMatch(label -> !label.getBoard().getId().equals(boardId))) {
            throw new BadRequestException("One or more labels do not belong to this board.");
        }

        card.setTitle(request.title().trim());
        card.setDescription(request.description() == null || request.description().isBlank()
                ? null : request.description());
        card.setPriority(request.priority());
        card.setDueDate(request.dueDate());
        card.setCompleted(request.completed());
        card.setAssignee(assignee);
        card.getLabels().clear();
        card.getLabels().addAll(newLabels);
        card.touch();
        return detail(card);
    }

    /** Moves a card to {@code position} in the target list (which may be its current list). */
    public void moveCard(Long cardId, MoveCardRequest request, Long userId) {
        Card card = requireCard(cardId, userId);
        BoardList source = card.getList();
        BoardList target = lists.findById(request.listId())
                .orElseThrow(() -> new NotFoundException("List not found."));
        if (!target.getBoard().getId().equals(source.getBoard().getId())) {
            throw new BadRequestException("Cards can only be moved within the same board.");
        }

        List<Card> targetCards = cards.findByListIdOrderByPosition(target.getId());
        if (!Objects.equals(source.getId(), target.getId())) {
            List<Card> sourceCards = cards.findByListIdOrderByPosition(source.getId());
            sourceCards.remove(card);
            Positioned.renumber(sourceCards);
            card.setList(target);
        }
        Positioned.moveTo(targetCards, card, request.position());
        card.touch();
        target.getBoard().touch();
    }

    public void deleteCard(Long cardId, Long userId) {
        Card card = requireCard(cardId, userId);
        Long listId = card.getList().getId();
        cards.delete(card);
        cards.flush();
        Positioned.renumber(cards.findByListIdOrderByPosition(listId));
    }

    // ---- Checklist ------------------------------------------------------------------------------------------

    public ChecklistItemResponse addChecklistItem(Long cardId, String content, Long userId) {
        Card card = requireCard(cardId, userId);
        ChecklistItem item = checklistItems.save(
                new ChecklistItem(card, content.trim(), checklistItems.countByCardId(cardId)));
        return ChecklistItemResponse.from(item);
    }

    public ChecklistItemResponse updateChecklistItem(Long itemId, UpdateChecklistItemRequest request, Long userId) {
        ChecklistItem item = requireChecklistItem(itemId, userId);
        item.setContent(request.content().trim());
        item.setDone(request.done());
        return ChecklistItemResponse.from(item);
    }

    public void deleteChecklistItem(Long itemId, Long userId) {
        ChecklistItem item = requireChecklistItem(itemId, userId);
        Long cardId = item.getCard().getId();
        checklistItems.delete(item);
        checklistItems.flush();
        Positioned.renumber(checklistItems.findByCardIdOrderByPosition(cardId));
    }

    // ---- Comments -------------------------------------------------------------------------------------------

    public CommentResponse addComment(Long cardId, String body, Long userId) {
        Card card = requireCard(cardId, userId);
        return CommentResponse.from(comments.save(new Comment(card, users.getReferenceById(userId), body.trim())));
    }

    /** Authors can delete their own comments. */
    public void deleteComment(Long commentId, Long userId) {
        Comment comment = comments.findById(commentId)
                .orElseThrow(() -> new NotFoundException("Comment not found."));
        access.requireMember(boardId(comment.getCard()), userId);
        if (!comment.getAuthor().getId().equals(userId)) {
            throw new ForbiddenException("You can only delete your own comments.");
        }
        comments.delete(comment);
    }

    // ---- Helpers --------------------------------------------------------------------------------------------

    private Card requireCard(Long cardId, Long userId) {
        Card card = cards.findById(cardId).orElseThrow(() -> new NotFoundException("Card not found."));
        access.requireMember(boardId(card), userId);
        return card;
    }

    private ChecklistItem requireChecklistItem(Long itemId, Long userId) {
        ChecklistItem item = checklistItems.findById(itemId)
                .orElseThrow(() -> new NotFoundException("Checklist item not found."));
        access.requireMember(boardId(item.getCard()), userId);
        return item;
    }

    private static Long boardId(Card card) {
        return card.getList().getBoard().getId();
    }

    private CardSummary summary(Card card) {
        return CardMapper.toSummary(card, new CardCounts(card.getId(), 0, 0), new CardCounts(card.getId(), 0, 0));
    }

    private CardDetail detail(Card card) {
        List<ChecklistItemResponse> checklist = checklistItems.findByCardIdOrderByPosition(card.getId()).stream()
                .map(ChecklistItemResponse::from).toList();
        List<CommentResponse> commentResponses = comments.findAllForCard(card.getId()).stream()
                .map(CommentResponse::from).toList();
        return new CardDetail(card.getId(), card.getList().getId(), card.getList().getName(), boardId(card),
                card.getTitle(), card.getDescription(), card.getPriority(), card.getDueDate(), card.isCompleted(),
                UserSummary.from(card.getAssignee()), CardDtos.labelIds(card), UserSummary.from(card.getCreatedBy()),
                card.getCreatedAt(), card.getUpdatedAt(), checklist, commentResponses);
    }
}
