
package com.carro.microservicio.service;

import com.carro.microservicio.entity.Carro;
import com.carro.microservicio.repository.CarroRepository;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author Hugo
 */
@Service
public class CarroServiceImpl implements CarroService{
    
    @Autowired
    private CarroRepository carroRepository;

    @Override
    public List<Carro> listarCarros() {
        
        return carroRepository.findAll();
    }

    @Override
    public Carro buscarCarroPorId(int id) {
       
        return carroRepository.findById(id).orElse(null);
    }

    @Override
    public Carro guardarCarro(Carro carro) {
        
        return carroRepository.save(carro);
    }

    @Override
    public List<Carro> buscarUsuarioDeCarroPorId(int usuarioId) {
        
       return carroRepository.findByUsuarioId(usuarioId);
    }
    
}
