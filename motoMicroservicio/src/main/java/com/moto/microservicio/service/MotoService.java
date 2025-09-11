
package com.moto.microservicio.service;

import com.moto.microservicio.entity.Moto;
import java.util.List;

/**
 *
 * @author Hugo
 */
public interface MotoService {
    
    public List<Moto> listarMotos();
    
    public Moto buscarMotoPorId(int id);
    
    public Moto guardarMoto(Moto moto);
    
    public List<Moto> buscarUsuarioDeMotoPorId(int usuarioId);
}
