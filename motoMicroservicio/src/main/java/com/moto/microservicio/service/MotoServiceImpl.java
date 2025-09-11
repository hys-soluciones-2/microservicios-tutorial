
package com.moto.microservicio.service;

import com.moto.microservicio.entity.Moto;
import com.moto.microservicio.repository.MotoRepository;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author Hugo
 */
@Service
public class MotoServiceImpl implements MotoService{
    
    @Autowired
    private MotoRepository motoRepository;

    @Override
    public List<Moto> listarMotos() {
        
      return motoRepository.findAll();
    }

    @Override
    public Moto buscarMotoPorId(int id) {
        
        return motoRepository.findById(id).orElse(null);
    }

    @Override
    public Moto guardarMoto(Moto moto) {
        
        return motoRepository.save(moto);
    }

    @Override
    public List<Moto> buscarUsuarioDeMotoPorId(int usuarioId) {
        
        return motoRepository.findByUsuarioId(usuarioId);
    }
    
}
