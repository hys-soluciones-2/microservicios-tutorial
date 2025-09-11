
package com.moto.microservicio.repository;

import com.moto.microservicio.entity.Moto;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Hugo
 */
@Repository
public interface MotoRepository extends JpaRepository<Moto, Integer>{
    
    List<Moto> findByUsuarioId(int usuarioId);
}
