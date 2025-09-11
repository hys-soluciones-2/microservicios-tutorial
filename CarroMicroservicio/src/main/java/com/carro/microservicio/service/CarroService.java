
package com.carro.microservicio.service;

import com.carro.microservicio.entity.Carro;
import java.util.List;

/**
 *
 * @author Hugo
 */
public interface CarroService {
    
    public List<Carro> listarCarros();
    
    public Carro buscarCarroPorId(int id);
    
    public Carro guardarCarro(Carro carro);
    
    public List<Carro> buscarUsuarioDeCarroPorId(int usuarioId);
     
   
    
}
