
package com.microservicio.repository;

import com.microservicio.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Hugo
 */
@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer>{
    
}
