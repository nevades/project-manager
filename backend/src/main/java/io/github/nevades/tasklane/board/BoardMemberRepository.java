package io.github.nevades.tasklane.board;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface BoardMemberRepository extends JpaRepository<BoardMember, Long> {

    Optional<BoardMember> findByBoardIdAndUserId(Long boardId, Long userId);

    @Query("select m from BoardMember m join fetch m.board b where m.user.id = :userId order by b.updatedAt desc")
    List<BoardMember> findAllForUser(Long userId);

    @Query("select m from BoardMember m join fetch m.user u where m.board.id = :boardId order by m.joinedAt")
    List<BoardMember> findAllForBoard(Long boardId);
}
