package io.github.nevades.tasklane.card;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    @Query("select c from Comment c join fetch c.author where c.card.id = :cardId order by c.createdAt desc")
    List<Comment> findAllForCard(Long cardId);
}
