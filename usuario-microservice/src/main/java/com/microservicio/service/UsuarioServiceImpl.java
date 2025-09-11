package com.microservicio.service;

import com.microservicio.entity.Usuario;
import com.microservicio.modelos.Carro;
import com.microservicio.modelos.Moto;
import com.microservicio.repository.UsuarioRepository;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.Value;
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

  //Metodos para crear desde Usuario motos y carros
   
    private String carroServiceUrl ="http://localhost:8002/carro" ;

   
    private String motoServiceUrl = "http://localhost:8003/moto" ;

    @Override
    public Carro crearCarro(Carro carro) {
        return restTemplate.postForObject(carroServiceUrl, carro, Carro.class);
    }

    @Override
    public Moto crearMoto(Moto moto) {
        return restTemplate.postForObject(motoServiceUrl, moto, Moto.class);
    }
    //-------------------------------------------------------------------------
    //Implementamos un metodo para obtener usuario y veiculos

    @Override
    public Map<String, Object> getUsuarioAndVeiculos(int usuarioId){
        //Creamos un Map
        Map<String, Object> resultado= new HashMap<>();
        //Buscamos el usuario
        Usuario usuario = usuarioRepository.findById(usuarioId).orElse(null);
        
        //Verificamos si el usuario Existe
        if(usuario == null){
            resultado.put("mensaje", "El usuario no existe");
            return resultado;
        }
        resultado.put("Usuario", usuario);
        //Buscamos la lista de Carros
         List<Carro> carros = restTemplate.getForObject("http://localhost:8002/carro/usuario/" + usuarioId, List.class);

         if(carros.isEmpty()){
             resultado.put("Carros", "El Usuario no tiene carros");
         }else{
             resultado.put("Carros", carros);
         }
         //Buscamos la lista de motos
          List<Moto> motos = restTemplate.getForObject("http://localhost:8003/moto/usuario/" + usuarioId, List.class);

         if(motos.isEmpty()){
             resultado.put("Motos", "La lista de Motos esta vacia");
         }else{
             resultado.put("Motos", motos);
         }
         return resultado;
    }



//-------------------------------------------------------------------------
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
