/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.repo;

import neva.project_manager.model.Parameter;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author nevanjith
 */
@Repository
public interface ParamRepo extends CrudRepository<Parameter, Integer> {

}
