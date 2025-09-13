package com.microservicio.service;

import com.microservicio.entity.Usuario;
import com.microservicio.modelos.Carro;
import com.microservicio.modelos.Moto;
import com.microservicio.repository.UsuarioRepository;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

/**
 *
 * @author Hugo
 */
@Service
public class UsuarioServiceImpl implements UsuarioService {

    //Inyectamos el microServicio
    @Autowired
    private RestTemplate restTemplate;

    //Creamos dos metodos más
    @Override
    public List<Carro> getCarros(int usuarioId) {
        List<Carro> carros = restTemplate.getForObject("http://localhost:8002/carro/usuario/" + usuarioId, List.class);

        return carros;
    }

    @Override
    public List<Moto> getMoto(int usuarioId) {
        List<Moto> motos = restTemplate.getForObject("http://localhost:8003/moto/usuario/" + usuarioId, List.class);

        return motos;
    }
 

    //---------------------------------------
    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public List<Usuario> listarUsuarios() {

        return usuarioRepository.findAll();
    }

    @Override
    public Usuario encontrarUsuarioPorId(int id) {

        return usuarioRepository.findById(id).orElse(null);
    }

    @Override
    public Usuario guardarUsuario(Usuario usuario) {

        Usuario usuarionuevo = usuarioRepository.save(usuario);

        return usuarionuevo;
    }

}
