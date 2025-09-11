package com.microservicio.service;

import com.microservicio.entity.Usuario;
import com.microservicio.modelos.Carro;
import com.microservicio.modelos.Moto;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Hugo
 */
public interface UsuarioService {

    public List<Carro> getCarros(int usuarioId);

    public List<Moto> getMoto(int usuarioId);

    public List<Usuario> listarUsuarios();

    public Usuario encontrarUsuarioPorId(int id);

    public Usuario guardarUsuario(Usuario usuario);

    public Carro crearCarro(Carro carro);

    public Moto crearMoto(Moto moto);
    
     public Map<String, Object> getUsuarioAndVeiculos(int usuarioId);
}
