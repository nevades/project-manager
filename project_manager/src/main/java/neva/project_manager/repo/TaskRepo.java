/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.repo;

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
}
