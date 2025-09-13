package com.usuario.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.usuario.entidades.Usuario;
import com.usuario.modelos.Carro;
import com.usuario.modelos.Moto;
import com.usuario.repository.UsuarioRepository;

@Service
public class UsuarioService {
	
	@Autowired
	private UsuarioRepository usuarioRepository;

	@Autowired
	private RestTemplate restTemplate;
	
	public List<Carro> getCarros(int usuarioId){
		List<Carro> carros = restTemplate.getForObject("http://localhost:8002/carro/usuario/" + usuarioId,	List.class );
		
		return carros;
	}
	
	public List<Moto> getMoto(int usuarioId){
		List<Moto> motos = restTemplate.getForObject("http://localhost:8003/moto/usuario/" + usuarioId,	List.class );
		
		return motos;
	}
	
	
	
	public List<Usuario> getAll(){
		return usuarioRepository.findAll();
	}
	
	
	public Usuario getUsuarioById(int id) {
		return usuarioRepository.findById(id).orElse(null);
		
	}
	
	public Usuario saveUsuario(Usuario usuario) {
		Usuario nuevoUsuario = usuarioRepository.save(usuario);
		
		return nuevoUsuario; 
	}
	
	
	
	
}
