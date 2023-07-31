/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.repo;

import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.model.Card;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 *
 * @author nevanjith
 */
@Repository
public interface CardRepo extends CrudRepository<Card, Integer> {

    @Query("SELECT `board_id`,`board_name`,`board_color`,(SELECT JSON_ARRAYAGG(JSON_OBJECT('id',`card_id`,'content',`card_content`))  FROM `card` c WHERE c.`board_id`=b.`board_id`) AS cards FROM `board` b WHERE `project_id`=1")
    Iterable<LoadBoardDTO> LoadBoard(@Param("uid") String uid);
}
