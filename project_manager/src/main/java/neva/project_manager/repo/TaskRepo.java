package neva.project_manager.repo;

import neva.project_manager.dto.LoadTaskCountDTO;
import neva.project_manager.dto.LoadTaskDTO;
import neva.project_manager.model.Task;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskRepo extends CrudRepository<Task, Integer> {

    @Query("SELECT `id`,`subject`,`description`,`priority`,`project_id`,`board_id` FROM `task` WHERE `status` = 'active'")
    Iterable<LoadTaskDTO> LoadTasks(@Param("uid") String uid);

    @Query("SELECT `id`,`subject`,`description` FROM `task` WHERE `board_id`=:tid AND `project_id`=:pid")
    LoadTaskDTO showData(@Param("tid") Integer tid, @Param("pid") Integer pid);

    @Query("SELECT p.`category_type`, COUNT(*) AS `no` FROM `task` t INNER JOIN `parameter` p ON t.`parameter_id` = p.`id` GROUP BY p.`category_type`")
    Iterable<LoadTaskCountDTO> countByStatus();

    @Query("SELECT COUNT(*) AS `no` FROM `task` t INNER JOIN `parameter` p ON t.`parameter_id` = p.`id` WHERE p.`category_type` NOT IN (1,2)")
    Iterable<LoadTaskCountDTO> loadOtherCount();

    @Query("SELECT COUNT(*) AS `no` FROM `task` t")
    Iterable<LoadTaskCountDTO> loadTotalCount();
}
