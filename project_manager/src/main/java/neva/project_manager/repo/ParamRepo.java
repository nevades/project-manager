/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.repo;

import neva.project_manager.dto.SlimSelectDTO;
import neva.project_manager.model.Parameter;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 *
 * @author nevanjith
 */
@Repository
public interface ParamRepo extends CrudRepository<Parameter, Integer> {

    @Query("SELECT `id` AS `value`,`category_name` AS `text` FROM `parameter` LIMIT 20")
    Iterable<SlimSelectDTO> getAllType(@Param("search") String search);
}
