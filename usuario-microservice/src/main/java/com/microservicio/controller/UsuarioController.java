package com.microservicio.controller;

import com.microservicio.entity.Usuario;
import com.microservicio.modelos.Carro;
import com.microservicio.modelos.Moto;
import com.microservicio.service.UsuarioService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 *
 * @author Hugo
 */
@RestController
@RequestMapping("/usuario")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping
    public ResponseEntity<List<Usuario>> listaUsuarios() {
        List<Usuario> usuarios = usuarioService.listarUsuarios();

        if (usuarios.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(usuarios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> obtenerUsuario(@PathVariable("id") int id) {
        Usuario usuario = usuarioService.encontrarUsuarioPorId(id);

        if (usuario == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(usuario);
    }

    @PostMapping
    public ResponseEntity<Usuario> guardarUsuario(@RequestBody Usuario usuario) {
        Usuario nuevoUsuario = usuarioService.guardarUsuario(usuario);

        return ResponseEntity.ok(nuevoUsuario);

    }
    //******************************************
    // Metodos para conectar los microservicios
    
    @GetMapping("carros/{usuarioId}")
	public ResponseEntity<List<Carro>> listarCarros(@PathVariable("usuarioId") int usuarioId){
		
		Usuario usuario = usuarioService.encontrarUsuarioPorId(usuarioId);
		
		if(usuario == null) {
			return ResponseEntity.notFound().build();
		}
		
		List<Carro> carros = usuarioService.getCarros(usuarioId);
		return ResponseEntity.ok(carros);
	}
	
	
	@GetMapping("motos/{usuarioId}")
	public ResponseEntity<List<Moto>> listarMotos(@PathVariable("usuarioId") int usuarioId){
		
		Usuario usuario = usuarioService.encontrarUsuarioPorId(usuarioId);
		
		if(usuario == null) {
			return ResponseEntity.notFound().build();
		}
		
		List<Moto> motos = usuarioService.getMoto(usuarioId);
		return ResponseEntity.ok(motos);
	}
	
//****************************************************************
    //Metodos para guardar la moto o el carro creado con el id del usuario    
           

    @PostMapping("/{usuarioId}/carros")
    public ResponseEntity<Carro> guardarCarro(@PathVariable int usuarioId, @RequestBody Carro carro) {
        
        carro.setUsuarioId(usuarioId);
        Carro nuevo = usuarioService.crearCarro(carro);
        return ResponseEntity.ok(nuevo);
    }

    @PostMapping("/{usuarioId}/motos")
    public ResponseEntity<Moto> guardarMoto(@PathVariable int usuarioId, @RequestBody Moto moto) {
        moto.setUsuarioId(usuarioId);
        Moto nueva = usuarioService.crearMoto(moto);
        return ResponseEntity.ok(nueva);
    }
    
    //***************************************************************
    //Metodo Get para obtener todo lo de un usuario
    
    @GetMapping("/todo/{usuarioId}")
    public ResponseEntity<Map<String,Object>> listarTodosLosVeiculos(@PathVariable("usuarioId") int usuarioId ){
           //Creamos un Map
        Map<String, Object> resultado= usuarioService.getUsuarioAndVeiculos(usuarioId);
        
        return ResponseEntity.ok(resultado);
    }

}
