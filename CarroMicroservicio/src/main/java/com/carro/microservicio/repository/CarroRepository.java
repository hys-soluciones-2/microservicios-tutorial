
package com.carro.microservicio.repository;

import com.carro.microservicio.entity.Carro;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Hugo
 */
@Repository
public interface CarroRepository extends JpaRepository<Carro, Integer>{
    
    List<Carro> findByUsuarioId(int usuarioId);
    
}
