package neva.project_manager.repo;

import neva.project_manager.dto.LoadParameterDTO;
import neva.project_manager.dto.SlimSelectDTO;
import neva.project_manager.model.Parameter;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ParamRepo extends CrudRepository<Parameter, Integer> {

    @Query("SELECT `id` AS `value`,`category_name` AS `text` FROM `parameter` WHERE `status`='active' LIMIT 20")
    Iterable<SlimSelectDTO> getAllType(@Param("search") String search);

    @Query("SELECT `id`,`category_name`,`category_type` FROM `parameter` WHERE `id` =:pid")
    LoadParameterDTO LoadParameter(@Param("pid") Integer pid);
}
