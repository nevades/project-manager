package io.github.nevades.tasklane.board;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LabelRepository extends JpaRepository<Label, Long> {

    List<Label> findByBoardIdOrderById(Long boardId);
}
