package io.github.nevades.tasklane.board;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BoardListRepository extends JpaRepository<BoardList, Long> {

    List<BoardList> findByBoardIdOrderByPosition(Long boardId);

    int countByBoardId(Long boardId);
}
