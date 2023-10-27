package neva.project_manager.repo;

import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.model.Board;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface BoardRepo extends CrudRepository<Board, Integer> {

    @Query("SELECT `board_id`,`board_name`,`board_color` FROM `board` b WHERE `project_id`=:projectId")
    Iterable<LoadBoardDTO> LoadBoard(@Param("uid") String uid, @Param("projectId") String projectId);
}
