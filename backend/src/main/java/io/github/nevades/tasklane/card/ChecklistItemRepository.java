package io.github.nevades.tasklane.card;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChecklistItemRepository extends JpaRepository<ChecklistItem, Long> {

    List<ChecklistItem> findByCardIdOrderByPosition(Long cardId);

    int countByCardId(Long cardId);
}
