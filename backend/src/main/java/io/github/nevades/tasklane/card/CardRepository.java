package io.github.nevades.tasklane.card;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface CardRepository extends JpaRepository<Card, Long> {

    List<Card> findByListIdOrderByPosition(Long listId);

    int countByListId(Long listId);

    @Query("""
            select distinct c from Card c
            left join fetch c.labels
            left join fetch c.assignee
            where c.list.board.id = :boardId
            order by c.position
            """)
    List<Card> findAllForBoard(Long boardId);

    /** Per-card checklist progress for every card on a board, used for card badges. */
    @Query("""
            select new io.github.nevades.tasklane.card.CardCounts(i.card.id, count(i),
                   sum(case when i.done = true then 1L else 0L end))
            from ChecklistItem i
            where i.card.list.board.id = :boardId
            group by i.card.id
            """)
    List<CardCounts> checklistCountsForBoard(Long boardId);

    @Query("""
            select new io.github.nevades.tasklane.card.CardCounts(c.card.id, count(c), 0L)
            from Comment c
            where c.card.list.board.id = :boardId
            group by c.card.id
            """)
    List<CardCounts> commentCountsForBoard(Long boardId);

    @Modifying
    @Query("""
            update Card c set c.assignee = null
            where c.assignee.id = :userId
              and c.list.id in (select l.id from BoardList l where l.board.id = :boardId)
            """)
    void unassignUserOnBoard(Long userId, Long boardId);
}
