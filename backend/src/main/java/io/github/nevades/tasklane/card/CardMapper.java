package io.github.nevades.tasklane.card;

import io.github.nevades.tasklane.card.CardDtos.CardSummary;
import io.github.nevades.tasklane.user.UserDtos.UserSummary;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

public final class CardMapper {

    private static final CardCounts NONE = new CardCounts(null, 0, 0);

    private CardMapper() {
    }

    /** Loads every card on a board with its badge counts in three queries. */
    public static List<CardSummary> summariesForBoard(CardRepository cards, Long boardId) {
        Map<Long, CardCounts> checklist = byCard(cards.checklistCountsForBoard(boardId));
        Map<Long, CardCounts> comments = byCard(cards.commentCountsForBoard(boardId));
        return cards.findAllForBoard(boardId).stream()
                .map(card -> toSummary(card,
                        checklist.getOrDefault(card.getId(), NONE),
                        comments.getOrDefault(card.getId(), NONE)))
                .toList();
    }

    static CardSummary toSummary(Card card, CardCounts checklist, CardCounts comments) {
        return new CardSummary(card.getId(), card.getList().getId(), card.getTitle(), card.getPosition(),
                card.getPriority(), card.getDueDate(), card.isCompleted(), UserSummary.from(card.getAssignee()),
                CardDtos.labelIds(card), card.getDescription() != null && !card.getDescription().isBlank(),
                checklist.done(), checklist.total(), comments.total());
    }

    private static Map<Long, CardCounts> byCard(List<CardCounts> counts) {
        return counts.stream().collect(Collectors.toMap(CardCounts::cardId, Function.identity()));
    }
}
